#!/usr/bin/env bash
set -euo pipefail

HUB_FILE="skillshare-hub.json"
BASE_REF="${1:-${BASE_SHA:-main}}"
REPORT_FILE="${AUDIT_REPORT:-}"

# Detect environment
is_ci() { [ "${CI:-}" = "true" ]; }
log_group() { is_ci && echo "::group::$1" || echo "=== $1 ==="; }
log_endgroup() { is_ci && echo "::endgroup::" || true; }
log_error() { is_ci && echo "::error::$1" || echo "ERROR: $1"; }

# --- Parse source into clone_url and subpath ---
# Output: clone_url<TAB>subpath
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

# --- Audit a single target and record results ---
# Sets: results[], details[], failed
audit_target() {
  local source="$1" audit_target="$2"

  local audit_json
  audit_json=$(skillshare audit "$audit_target" --threshold high --json 2>/dev/null) || true

  if ! echo "$audit_json" | jq -e '.summary' >/dev/null 2>&1; then
    local audit_err
    audit_err=$(skillshare audit "$audit_target" --threshold high 2>&1) || true
    echo "$audit_err"
    results+=("| \`${source}\` | :x: Error | - |")
    details+=("DETAIL_SEP### \`${source}\`"$'\n'"\`\`\`"$'\n'"${audit_err}"$'\n'"\`\`\`")
    failed=1
    return
  fi

  local risk_score risk_label risk findings_text audit_display
  risk_score=$(echo "$audit_json" | jq -r '.summary.riskScore')
  risk_label=$(echo "$audit_json" | jq -r '.summary.riskLabel' | tr '[:lower:]' '[:upper:]')
  risk="${risk_label} (${risk_score}/100)"

  findings_text=$(echo "$audit_json" | jq -r '
    [.results[] | (.findings // [])[] | "  \(.severity): \(.message) (\(.file):\(.line))\n  \"\(.snippet)\""]
    | join("\n\n")')
  audit_display="Risk: ${risk}"
  [ -n "$findings_text" ] && audit_display="${audit_display}"$'\n\n'"${findings_text}"
  echo "$audit_display"

  if [[ "$risk_label" == "HIGH" || "$risk_label" == "CRITICAL" ]]; then
    results+=("| \`${source}\` | :x: Risk ${risk_label} | ${risk} |")
    details+=("DETAIL_SEP### \`${source}\`"$'\n'"\`\`\`"$'\n'"${audit_display}"$'\n'"\`\`\`")
    log_error "Risk ${risk_label} for ${source}"
    failed=1
  else
    results+=("| \`${source}\` | :white_check_mark: Passed | ${risk} |")
    details+=("DETAIL_SEP### \`${source}\`"$'\n'"\`\`\`"$'\n'"${audit_display}"$'\n'"\`\`\`")
  fi
}

# --- Find new/changed sources ---
base_sources=$(git show "${BASE_REF}:${HUB_FILE}" 2>/dev/null \
  | jq -r '.skills[] | "\(.name)|\(.source)"' | sort) || base_sources=""

pr_sources=$(jq -r '.skills[] | "\(.name)|\(.source)"' "$HUB_FILE" | sort)

new_entries=$(comm -13 <(echo "$base_sources") <(echo "$pr_sources"))
new_sources=$(echo "$new_entries" | cut -d'|' -f2 | sort -u)

if [ -z "$new_entries" ]; then
  echo "No new or changed skill sources to audit"
  [ -n "$REPORT_FILE" ] && echo "No new or changed skill sources to audit." > "$REPORT_FILE"
  exit 0
fi

# --- Check skillshare is available ---
if ! command -v skillshare &>/dev/null; then
  echo "ERROR: skillshare CLI not found. Install from https://github.com/runkids/skillshare"
  exit 1
fi

# --- Group sources by clone_url (clone once per repo) ---
# Use temp dir instead of associative arrays (Bash 3.x compat)
group_dir=$(mktemp -d)
trap 'rm -rf "$group_dir"' EXIT
clone_order_file="$group_dir/_order"
touch "$clone_order_file"

while IFS= read -r source; do
  [ -z "$source" ] && continue

  parsed=$(parse_source "$source")
  clone_url=$(echo "$parsed" | cut -f1)
  subpath=$(echo "$parsed" | cut -f2)

  safe_name=$(echo "$clone_url" | sed 's|https://||;s|\.git$||' | tr '/:' '-')
  if ! grep -qxF "$safe_name" "$clone_order_file" 2>/dev/null; then
    echo "$safe_name" >> "$clone_order_file"
    echo "$clone_url" > "$group_dir/${safe_name}.url"
  fi
  printf '%s\t%s\n' "$source" "$subpath" >> "$group_dir/${safe_name}.sources"
done <<< "$new_sources"

unique_repos=$(wc -l < "$clone_order_file" | tr -d ' ')
echo "New/changed sources to audit: $(echo "$new_sources" | wc -l | tr -d ' ') sources across ${unique_repos} repos"
echo ""

# --- Audit each repo ---
failed=0
results=()
details=()

while IFS= read -r safe_name; do
  [ -z "$safe_name" ] && continue
  clone_url=$(cat "$group_dir/${safe_name}.url")
  clone_dir="/tmp/audit-${safe_name}"
  rm -rf "$clone_dir"

  log_group "Cloning ${clone_url}"

  if ! clone_output=$(git clone --depth 1 "$clone_url" "$clone_dir" 2>&1); then
    # Clone failed — mark all sources in this repo as failed
    while IFS=$'\t' read -r source subpath; do
      [ -z "$source" ] && continue
      log_error "Failed to clone ${source}"
      results+=("| \`${source}\` | :x: Clone failed | - |")
      details+=("DETAIL_SEP### \`${source}\`"$'\n'"Clone failed:"$'\n'"\`\`\`"$'\n'"${clone_output}"$'\n'"\`\`\`")
      failed=1
    done < "$group_dir/${safe_name}.sources"
    rm -rf "$clone_dir"
    log_endgroup
    continue
  fi

  echo "Cloned ${clone_url} — auditing subpaths..."

  # Audit each source/subpath in this repo
  while IFS=$'\t' read -r source subpath; do
    [ -z "$source" ] && continue

    local_target="$clone_dir"
    if [ -n "$subpath" ] && [ -d "$clone_dir/$subpath" ]; then
      local_target="$clone_dir/$subpath"
    fi

    echo "  Auditing: ${source}"
    audit_target "$source" "$local_target"
  done < "$group_dir/${safe_name}.sources"

  rm -rf "$clone_dir"
  log_endgroup
done < "$clone_order_file"

# --- Generate report ---
if [ -n "$REPORT_FILE" ]; then
  {
    echo "## Skill Audit Results"
    echo ""
    echo "Audited $(echo "$new_sources" | wc -l | tr -d ' ') sources across ${unique_repos} repos."
    echo ""
    echo "| Source | Status | Risk |"
    echo "|--------|--------|------|"
    for row in "${results[@]}"; do
      echo "$row"
    done
    echo ""
    if [ "$failed" -ne 0 ]; then
      echo "> **Failed**: One or more skills did not pass the security audit."
    else
      echo "> **All skills passed** the security audit."
    fi
    echo ""
    echo "<details>"
    echo "<summary>Audit Details</summary>"
    echo ""
    for detail in "${details[@]}"; do
      echo "${detail}" | sed 's/^DETAIL_SEP//'
      echo ""
    done
    echo "</details>"
  } > "$REPORT_FILE"
fi

if [ "$failed" -ne 0 ]; then
  echo ""
  log_error "One or more skills failed the security audit. Please fix the flagged issues and push again."
  exit 1
fi

echo "All new skills passed the security audit"
