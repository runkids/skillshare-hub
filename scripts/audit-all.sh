#!/usr/bin/env bash
set -euo pipefail

HUB_FILE="skillshare-hub.json"

if [ ! -f "$HUB_FILE" ]; then
  echo "ERROR: $HUB_FILE not found. Run 'make build' first."
  exit 1
fi

# --- Check skillshare CLI ---
if ! command -v skillshare &>/dev/null; then
  echo "WARN: skillshare CLI not found — skipping audit enrichment."
  exit 0
fi

# --- Parse source into clone_url and subpath ---
parse_source() {
  local source="$1"
  local clone_url="" subpath=""

  if [[ "$source" =~ ^https?://github\.com/([^/]+/[^/]+)/tree/[^/]+/(.+)$ ]]; then
    clone_url="https://github.com/${BASH_REMATCH[1]}.git"
    subpath="${BASH_REMATCH[2]}"
  elif [[ "$source" =~ ^https?://github\.com/([^/]+/[^/]+)/?$ ]]; then
    clone_url="https://github.com/${BASH_REMATCH[1]}.git"
  elif [[ "$source" =~ ^github\.com/([^/]+/[^/]+)(/(.+))?$ ]]; then
    clone_url="https://github.com/${BASH_REMATCH[1]}.git"
    subpath="${BASH_REMATCH[3]}"
  elif [[ "$source" =~ ^(https?://[^/]+)/([^/]+/[^/]+)/src/branch/[^/]+/(.+)$ ]]; then
    clone_url="${BASH_REMATCH[1]}/${BASH_REMATCH[2]}.git"
    subpath="${BASH_REMATCH[3]}"
  elif [[ "$source" =~ ^(https?://[^/]+)/([^/]+/[^/]+)/src/branch/ ]]; then
    clone_url="${BASH_REMATCH[1]}/${BASH_REMATCH[2]}.git"
  elif [[ "$source" == http* ]]; then
    clone_url="$source"
  else
    local owner_repo
    owner_repo=$(echo "$source" | cut -d'/' -f1-2)
    subpath=$(echo "$source" | cut -d'/' -f3-)
    clone_url="https://github.com/${owner_repo}.git"
  fi

  printf '%s\t%s' "$clone_url" "$subpath"
}

# --- Read all skills from hub JSON ---
skills_tsv=$(jq -r '.skills[] | [.name, .source, (.skill // "")] | @tsv' "$HUB_FILE")

if [ -z "$skills_tsv" ]; then
  echo "No skills found in $HUB_FILE"
  exit 0
fi

skill_count=$(echo "$skills_tsv" | wc -l | tr -d ' ')
echo "Auditing $skill_count skills from $HUB_FILE..."

# --- Group by clone_url (clone once per repo) ---
group_dir=$(mktemp -d)
trap 'rm -rf "$group_dir"' EXIT
clone_order_file="$group_dir/_order"
touch "$clone_order_file"

while IFS=$'\t' read -r name source skill; do
  [ -z "$source" ] && continue

  parsed=$(parse_source "$source")
  clone_url=$(echo "$parsed" | cut -f1)
  subpath=$(echo "$parsed" | cut -f2)

  safe_name=$(echo "$clone_url" | sed 's|https://||;s|\.git$||' | tr '/:' '-')
  if ! grep -qxF "$safe_name" "$clone_order_file" 2>/dev/null; then
    echo "$safe_name" >> "$clone_order_file"
    echo "$clone_url" > "$group_dir/${safe_name}.url"
  fi
  printf '%s|%s|%s|%s\n' "$name" "$source" "$subpath" "$skill" >> "$group_dir/${safe_name}.sources"
done <<< "$skills_tsv"

unique_repos=$(wc -l < "$clone_order_file" | tr -d ' ')
echo "Grouped into $unique_repos unique repos"
echo ""

# --- Audit each repo ---
audit_map="{}"
audited=0
skipped=0
now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

while IFS= read -r safe_name; do
  [ -z "$safe_name" ] && continue
  clone_url=$(cat "$group_dir/${safe_name}.url")
  clone_dir="/tmp/audit-all-${safe_name}"
  rm -rf "$clone_dir"

  echo "=== Cloning ${clone_url} ==="

  if ! git clone --depth 1 "$clone_url" "$clone_dir" 2>/dev/null; then
    echo "  WARN: Clone failed — skipping all skills in this repo"
    skipped=$(( skipped + $(wc -l < "$group_dir/${safe_name}.sources" | tr -d ' ') ))
    continue
  fi

  while IFS='|' read -r name source subpath skill; do
    [ -z "$name" ] && continue

    local_target="$clone_dir"
    if [ -n "$subpath" ] && [ -d "$clone_dir/$subpath" ]; then
      local_target="$clone_dir/$subpath"
    elif [ -n "$skill" ] && [ -d "$clone_dir/skills/$skill" ]; then
      local_target="$clone_dir/skills/$skill"
    else
      skill_md=$(find "$clone_dir" -maxdepth 3 -name "SKILL.md" -print -quit 2>/dev/null)
      if [ -n "$skill_md" ]; then
        local_target=$(dirname "$skill_md")
      fi
    fi

    echo "  Auditing: ${name} -> ${local_target}"

    audit_json=$(skillshare audit "$local_target" --json 2>/dev/null | sed '/^$/,$d') || true

    if ! echo "$audit_json" | jq -e '.summary' >/dev/null 2>&1; then
      echo "    WARN: Audit failed for ${name} — skipping"
      skipped=$(( skipped + 1 ))
      continue
    fi

    risk_score=$(echo "$audit_json" | jq -r '.summary.riskScore')
    risk_label=$(echo "$audit_json" | jq -r '.summary.riskLabel')

    echo "    Result: ${risk_label} (${risk_score}/100)"

    # Add to audit map
    audit_map=$(echo "$audit_map" | jq \
      --arg name "$name" \
      --argjson score "$risk_score" \
      --arg label "$risk_label" \
      --arg ts "$now" \
      '. + {($name): {riskScore: $score, riskLabel: $label, auditedAt: $ts}}')

    audited=$(( audited + 1 ))
  done < "$group_dir/${safe_name}.sources"

  rm -rf "$clone_dir"
done < "$clone_order_file"

echo ""
echo "Audited: $audited | Skipped: $skipped"

# --- Merge audit results into hub JSON ---
if [ "$audited" -gt 0 ]; then
  jq --argjson audit "$audit_map" '
    .skills = [.skills[] |
      if $audit[.name] then
        . + $audit[.name]
      else
        del(.riskScore, .riskLabel, .auditedAt)
      end
    ]
  ' "$HUB_FILE" > "${HUB_FILE}.tmp" && mv "${HUB_FILE}.tmp" "$HUB_FILE"
  echo "Enriched $HUB_FILE with audit scores"
else
  echo "No audit results to merge"
fi
