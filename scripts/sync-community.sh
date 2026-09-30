#!/usr/bin/env bash
set -euo pipefail

# Sync top community skills into the hub.
# Fetches the skills.sh all-time and trending (24h) leaderboards, adds newcomers
# to skills/community.json, and prunes entries that should no longer be listed:
#   - any entry whose source no longer resolves (repo missing or archived, or
#     the skill's SKILL.md is gone);
#   - any entry that duplicates another entry's skill directory;
#   - community entries that left the ranking AND whose repo has had no commit
#     in the last --stale-days days.
# Curated vendor files (everything except community.json) only lose entries
# for the first two reasons.
#
# Usage: ./scripts/sync-community.sh [--top N] [--trending N] [--stale-days N] [--dry-run]
#
# SYNC_SUMMARY=<file> writes a Markdown summary of adds/removals (used as the PR body).
# The archived check needs an authenticated `gh` (GH_TOKEN in CI); without it,
# archived repos are only caught once their files disappear.

TOP_N=200
TRENDING_N=50
STALE_DAYS=182
DRY_RUN=false
SUMMARY_FILE="${SYNC_SUMMARY:-}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --top) TOP_N="$2"; shift 2 ;;
    --trending) TRENDING_N="$2"; shift 2 ;;
    --stale-days) STALE_DAYS="$2"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

HUB_FILE="skillshare-hub.json"
SKILLS_DIR="skills"

if [ ! -f "$HUB_FILE" ]; then
  echo "ERROR: $HUB_FILE not found. Run 'make build' first."
  exit 1
fi

work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT

# --- Fetch leaderboards ---
# Prints the initialSkills JSON array embedded in a skills.sh page.
fetch_ranking() {
  local url="$1" html skills_json
  html=$(curl -fsSL "$url" 2>/dev/null) || return 1

  # Extract initialSkills JSON from RSC payload in <script> tags.
  # The data is in a self.__next_f.push([1,"..."]) call with escaped JSON.
  skills_json=$(echo "$html" | \
    grep -o 'initialSkills[^]]*\]' | head -1 | \
    sed 's/^initialSkills\\":\[/[/' | \
    sed 's/\\"/"/g' | \
    sed 's/\\\\/\\/g') || true

  if [ -z "$skills_json" ] || ! echo "$skills_json" | jq -e '.[0].name' >/dev/null 2>&1; then
    # Fallback: try node to parse (more reliable for complex escaping)
    skills_json=$(node -e "
      const html = require('fs').readFileSync('/dev/stdin', 'utf8');
      // Match each push([1,\"<escaped>\"]) individually — the inner payload is a
      // JSON-escaped string, so a single push never contains an unescaped quote.
      // (A lazy .*? across pushes would splice in other pushes' raw quotes and
      // break JSON.parse, since initialSkills now lives in a later chunk.)
      const re = /self\.__next_f\.push\(\[1,\"((?:\\\\.|[^\"\\\\])*)\"\]\)/g;
      let m, payload = null;
      while ((m = re.exec(html)) !== null) {
        if (m[1].includes('initialSkills')) { payload = m[1]; break; }
      }
      if (!payload) { process.exit(1); }
      const inner = JSON.parse('\"' + payload + '\"');
      const idx = inner.indexOf('\"initialSkills\":');
      const arrStart = idx + '\"initialSkills\":'.length;
      // State-aware bracket matching: ignore '[' / ']' inside string literals
      // (e.g. a skill description like \"Support for [Markdown]\"), which would
      // otherwise unbalance the depth counter and truncate the JSON.
      let depth = 0, i = arrStart;
      let inStr = false, esc = false;
      for (; i < inner.length; i++) {
        const c = inner[i];
        if (esc) { esc = false; continue; }
        if (c === '\\\\') { esc = true; continue; }
        if (c === '\"') { inStr = !inStr; continue; }
        if (inStr) continue;
        if (c === '[') depth++;
        else if (c === ']') { depth--; if (depth === 0) break; }
      }
      console.log(inner.substring(arrStart, i + 1));
    " <<< "$html") || return 1
  fi

  echo "$skills_json"
}

echo "Fetching top $TOP_N all-time and top $TRENDING_N trending community skills..."

all_time=$(fetch_ranking "https://skills.sh/") || {
  echo "ERROR: Failed to fetch or parse the leaderboard. Page format may have changed."
  exit 1
}
trending="[]"
if [ "$TRENDING_N" -gt 0 ]; then
  trending=$(fetch_ranking "https://skills.sh/trending") || {
    echo "ERROR: Failed to fetch or parse the trending leaderboard."
    exit 1
  }
fi

echo "Fetched $(echo "$all_time" | jq 'length') all-time and $(echo "$trending" | jq 'length') trending skills"

# Ranking = all-time top N + trending top M, GitHub sources with valid names,
# deduped by name (first occurrence wins; a skill in both lists keeps both signals).
ranked=$(jq -n --argjson all "$all_time" --argjson trend "$trending" \
  --argjson n "$TOP_N" --argjson m "$TRENDING_N" '
  ($all[:$n] | to_entries | map(.value + {signal: "all-time #\(.key + 1)"})) +
  ($trend[:$m] | to_entries | map(.value + {signal: "trending #\(.key + 1)"})) |
  [.[] |
    select(.source | test("^[A-Za-z0-9-]+/[A-Za-z0-9._-]+$")) |
    select(.name | test("^[a-z0-9][a-z0-9-]*$"))
  ] |
  reduce .[] as $item ({};
    if .[$item.name] == null then . + {($item.name): $item}
    elif .[$item.name].source == $item.source then .[$item.name].signal += ", \($item.signal)"
    else . end) |
  [.[]]
')
ranked_names=$(echo "$ranked" | jq '[.[].name]')

community_file="$SKILLS_DIR/community.json"

# --- Prune: check every hub entry against its repo ---
echo ""
echo "Checking sources of existing entries..."

HAS_GH=false
if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  HAS_GH=true
else
  echo "  WARN: gh not authenticated — skipping archived-repo check."
fi

cutoff=$(( $(date +%s) - STALE_DAYS * 86400 ))

# Writes <dir>/state (ok|missing|archived|error), and for ok repos
# <dir>/skill_dirs (every directory holding a SKILL.md, "." for the root)
# and <dir>/last_commit (epoch of the default branch's HEAD commit).
inspect_repo() {
  local repo="$1" dir="$2" err archived
  mkdir -p "$dir"

  if [ "$HAS_GH" = true ]; then
    if archived=$(gh api "repos/$repo" --jq '.archived' 2>"$dir/gh.err"); then
      if [ "$archived" = true ]; then echo archived > "$dir/state"; return 0; fi
    elif grep -q 'HTTP 404' "$dir/gh.err"; then
      echo missing > "$dir/state"; return 0
    fi
  fi

  # Tree-only shallow clone: file names without file contents.
  if ! err=$(GIT_TERMINAL_PROMPT=0 git clone -q --depth 1 --filter=blob:none --no-checkout \
      "https://github.com/${repo}.git" "$dir/repo" 2>&1); then
    if echo "$err" | grep -qiE 'not found|could not read Username'; then
      echo missing > "$dir/state"
    else
      echo "  WARN: could not inspect $repo (keeping its entries): $(echo "$err" | tail -1)" >&2
      echo error > "$dir/state"
    fi
    return 0
  fi

  git -C "$dir/repo" ls-tree -r --name-only HEAD | grep -E '(^|/)SKILL\.md$' | \
    sed -E 's#/?SKILL\.md$##; s#^$#.#' > "$dir/skill_dirs" || true
  git -C "$dir/repo" log -1 --format=%ct > "$dir/last_commit"
  echo ok > "$dir/state"
}

# Prints the entry's skill directory, following audit-all.sh's lookup order
# (without its depth limit, so plugins/<p>/skills/<name> still resolves),
# or nothing when no SKILL.md can be found for it.
resolve_skill_dir() {
  local dirs="$1" subpath="$2" skill="$3" name="$4" lookup d
  lookup="${skill:-$name}"
  for d in "$subpath" "skills/$lookup" "plugins/$lookup"; do
    if [ -n "$d" ] && grep -qxF "$d" "$dirs"; then echo "$d"; return 0; fi
  done
  for d in "$lookup" "$name"; do
    d=$(awk -F/ -v l="$d" '$NF == l { print; exit }' "$dirs")
    if [ -n "$d" ]; then echo "$d"; return 0; fi
  done
  if [ -z "$subpath" ] && [ -z "$skill" ] && grep -qxF "." "$dirs"; then echo "."; fi
  return 0
}

removals="$work_dir/removals.tsv"   # file <TAB> name <TAB> reason
kept_keys="$work_dir/kept_keys.tsv" # repo:dir <TAB> name
: > "$removals"
: > "$kept_keys"

while IFS=$'\t' read -r file name source skill; do
  # Only GitHub owner/repo[/subpath] sources can be checked; keep the rest.
  if [[ "$source" == http* ]] || [[ ! "$source" =~ ^[A-Za-z0-9-]+/[A-Za-z0-9._-]+ ]]; then
    continue
  fi
  repo=$(echo "$source" | cut -d'/' -f1-2)
  subpath=$(echo "$source" | cut -d'/' -f3-)
  repo_dir="$work_dir/repos/$(echo "$repo" | tr '[:upper:]/' '[:lower:]_')"
  [ -f "$repo_dir/state" ] || inspect_repo "$repo" "$repo_dir"

  reason=""
  case "$(cat "$repo_dir/state")" in
    missing) reason="repo not found" ;;
    archived) reason="repo archived" ;;
    error) continue ;;
    ok)
      found=$(resolve_skill_dir "$repo_dir/skill_dirs" "$subpath" "$skill" "$name")
      key="$(echo "$repo" | tr '[:upper:]' '[:lower:]'):$found"
      if [ -z "$found" ]; then
        reason="SKILL.md not found in repo"
      elif dup=$(awk -F'\t' -v k="$key" '$1 == k { print $2; exit }' "$kept_keys") && [ -n "$dup" ]; then
        reason="duplicate of $dup"
      elif [ "$(basename "$file")" = "community.json" ] && \
          ! echo "$ranked_names" | jq -e --arg n "$name" 'index($n)' >/dev/null && \
          [ "$(cat "$repo_dir/last_commit")" -lt "$cutoff" ]; then
        reason="left ranking; last commit $(date -u -d "@$(cat "$repo_dir/last_commit")" +%F 2>/dev/null || date -u -r "$(cat "$repo_dir/last_commit")" +%F)"
      else
        printf '%s\t%s\n' "$key" "$name" >> "$kept_keys"
      fi
      ;;
  esac

  if [ -n "$reason" ]; then
    printf '%s\t%s\t%s\n' "$file" "$name" "$reason" >> "$removals"
  fi
done < <(jq -r 'input_filename as $f | .[] | [$f, .name, .source, (.skill // "")] | @tsv' "$SKILLS_DIR"/*.json)

removed_count=$(wc -l < "$removals" | tr -d ' ')

# --- Newcomers: ranked skills not already in the hub ---
hub_names=$(jq '[.skills[].name]' "$HUB_FILE")
new_skills=$(echo "$ranked" | jq --argjson existing "$hub_names" '
  [.[] | select(.name as $n | ($existing | index($n)) == null)] | sort_by(.name)
')
new_count=$(echo "$new_skills" | jq 'length')

echo "Ranking: $(echo "$ranked" | jq 'length') skills → $new_count new candidates, $removed_count to remove"

if [ "$DRY_RUN" = true ]; then
  echo ""
  echo "=== DRY RUN ==="
  echo "--- Would ADD ($new_count, before directory/audit validation) ---"
  echo "$new_skills" | jq -r '.[] | "  + \(.name) (\(.source)) [\(.signal)]"'
  echo "--- Would REMOVE ($removed_count) ---"
  awk -F'\t' '{ printf "  - %s (%s): %s\n", $2, $1, $3 }' "$removals"
  exit 0
fi

if [ "$new_count" -eq 0 ] && [ "$removed_count" -eq 0 ]; then
  echo "Hub already matches the ranking. Nothing to do."
  exit 0
fi

# --- Tag inference from skill name and source ---
infer_tags() {
  local name="$1" source="$2"
  local tags=""

  # Source-based tags
  case "$source" in
    microsoft/github-copilot-for-azure*) tags="devops,backend" ;;
  esac

  # Name-based tags (only if not already tagged)
  if [ -z "$tags" ]; then
    case "$name" in
      *react-native*|*react*|*next*|*expo-*) tags="react,frontend" ;;
      *vue*|*nuxt*|*pinia*|*vueuse*) tags="vue,frontend" ;;
      *angular*) tags="frontend" ;;
      *flutter*|*swiftui*) tags="frontend" ;;
      *tailwind*|*shadcn*|*unocss*|*css*) tags="design,frontend" ;;
      *design*|*ui-*|*brand*|*theme*) tags="design,frontend" ;;
      *seo*|*backlink*) tags="seo" ;;
      *marketing*|*copywriting*|*content*) tags="marketing" ;;
      *test*|*tdd*|*e2e*|*jest*|*vitest*) tags="testing" ;;
      *code-review*) tags="code-review" ;;
      *docker*|*k8s*|*kubernetes*|*cicd*|*deploy*|*github-actions*|*turborepo*) tags="devops" ;;
      *security*|*auth*|*rbac*|*compliance*) tags="security" ;;
      *agent*|*browser-use*|*mcp*|*firecrawl*) tags="agent" ;;
      *ai*|*prompt*|*llm*|*humanizer*|*nblm*) tags="ai" ;;
      *git*|*workflow*|*plan*|*debug*|*skill*|*pnpm*) tags="workflow" ;;
      *doc*|*pdf*|*pptx*|*xlsx*|*vitepress*|*obsidian*) tags="docs" ;;
      *python*|*fastapi*|*django*|*flask*) tags="backend" ;;
      *golang*|*go-*|*laravel*|*nestjs*|*node*|*backend*|*postgres*|*sql*|*stripe*|*convex*) tags="backend" ;;
      *typescript*|*javascript*|*vite*|*frontend*|*responsive*) tags="frontend" ;;
      *baoyu*|*image*|*comic*|*slide*|*infographic*) tags="ai,workflow" ;;
      *) tags="workflow" ;;
    esac
  fi

  echo "$tags"
}

# --- Description inference from skill name ---
infer_description() {
  local name="$1" source="$2"
  local desc=""

  # Replace hyphens with spaces, capitalize first letter
  local readable
  readable=$(echo "$name" | sed 's/-/ /g')

  case "$name" in
    *best-practices) desc="$(echo "$readable" | sed 's/ best practices//' | sed 's/\b\(.\)/\u\1/g') best practices and recommended patterns" ;;
    *-patterns) desc="$(echo "$readable" | sed 's/ patterns//' | sed 's/\b\(.\)/\u\1/g') patterns and implementation guidelines" ;;
    *-templates) desc="$(echo "$readable" | sed 's/ templates//' | sed 's/\b\(.\)/\u\1/g') project templates and boilerplate generation" ;;
    *-expert|*-specialist) desc="$(echo "$readable" | sed 's/ expert//;s/ specialist//' | sed 's/\b\(.\)/\u\1/g') expertise and development best practices" ;;
    azure-*) desc="Azure $(echo "$readable" | sed 's/azure //' | sed 's/\b\(.\)/\u\1/g') management and best practices" ;;
    baoyu-*) desc="$(echo "$readable" | sed 's/baoyu //' | sed 's/\b\(.\)/\u\1/g') content creation tool from Baoyu suite" ;;
    *) desc="$(echo "$readable" | sed 's/\b\(.\)/\u\1/g') skill for AI agent workflows" ;;
  esac

  echo "$desc"
}

# --- Security audit gate ---
# Newcomers flagged HIGH/CRITICAL by `skillshare audit` are not added, so the
# community list never collects skills that would fail the PR audit job.
AUDIT_AVAILABLE=true
if ! command -v skillshare >/dev/null 2>&1; then
  AUDIT_AVAILABLE=false
  echo "  WARN: skillshare CLI not found — skipping security audit (no risk filtering)."
fi

# Returns 0 if safe to include, 1 if HIGH/CRITICAL risk.
audit_risk_ok() {
  local dir="$1"
  [ "$AUDIT_AVAILABLE" = false ] && return 0
  local risk
  # Strip trailing non-JSON output (e.g. upgrade notices) before parsing.
  risk=$(skillshare audit "$dir" --threshold high --format json --yes 2>/dev/null \
    | sed '/^$/,$d' | jq -r '.summary.riskLabel // empty' 2>/dev/null | tr '[:lower:]' '[:upper:]')
  case "$risk" in
    HIGH|CRITICAL) return 1 ;;
    *) return 0 ;;
  esac
}

# --- Clone repos and validate skill directories exist ---
echo ""
echo "Validating skill directories..."

clone_cache="$work_dir/clones"
mkdir -p "$clone_cache"

# Group new skills by repo for efficient cloning
repo_groups=$(echo "$new_skills" | jq -r '.[] | .source' | sort -u)

for repo in $repo_groups; do
  clone_url="https://github.com/${repo}.git"
  safe=$(echo "$repo" | tr '/' '-')
  if ! git clone --depth 1 "$clone_url" "$clone_cache/$safe" 2>/dev/null; then
    echo "  WARN: clone failed for $repo — skipping all its skills"
  fi
done

# Filter: keep only skills whose directory can be resolved
validated_skills=$(echo "$new_skills" | jq -c '.[]' | while IFS= read -r skill_obj; do
  sname=$(echo "$skill_obj" | jq -r '.name')
  ssource=$(echo "$skill_obj" | jq -r '.source')
  sskill_id=$(echo "$skill_obj" | jq -r '.skillId')
  safe=$(echo "$ssource" | tr '/' '-')
  clone_dir="$clone_cache/$safe"

  [ ! -d "$clone_dir" ] && continue

  lookup="$sskill_id"
  found=""

  # Try common directory conventions
  if [ -d "$clone_dir/skills/$lookup" ]; then
    found="skills/$lookup"
  elif [ -d "$clone_dir/plugins/$lookup" ]; then
    found="plugins/$lookup"
  elif [ -d "$clone_dir/$lookup" ]; then
    found="$lookup"
  else
    # Find SKILL.md matching this skill name
    skill_md=$(find "$clone_dir" -name "SKILL.md" -path "*/$lookup/SKILL.md" -not -path "*/.git/*" -print -quit 2>/dev/null)
    if [ -n "$skill_md" ]; then
      found=$(dirname "$skill_md" | sed "s|$clone_dir/||")
    fi
  fi

  key="$(echo "$ssource" | tr '[:upper:]' '[:lower:]'):$found"
  if [ -z "$found" ]; then
    echo "  SKIP: $sname — no directory found in $ssource" >&2
  elif dup=$(awk -F'\t' -v k="$key" '$1 == k { print $2; exit }' "$kept_keys") && [ -n "$dup" ]; then
    echo "  SKIP: $sname — same skill as existing entry $dup" >&2
  elif audit_risk_ok "$clone_dir/$found"; then
    echo "$skill_obj"
  else
    echo "  SKIP: $sname — failed security audit (HIGH/CRITICAL) in $ssource" >&2
  fi
done | jq -s '.')

validated_count=$(echo "$validated_skills" | jq 'length')
skipped_count=$((new_count - validated_count))

echo "Validated: $validated_count | Skipped (no dir / duplicate / failed audit): $skipped_count"

if [ "$validated_count" -eq 0 ] && [ "$removed_count" -eq 0 ]; then
  echo "No changes after validation."
  exit 0
fi

# --- Generate entries for newcomers ---
new_entries="[]"

while IFS=$'\t' read -r name source skill_id; do
  [ -z "$name" ] && continue

  desc=$(infer_description "$name" "$source")
  tags_csv=$(infer_tags "$name" "$source")

  src_field="$source/$skill_id"
  tags_json=$(echo "$tags_csv" | tr ',' '\n' | jq -R . | jq -s '.')

  repo_basename=$(basename "$source")
  if [ "$skill_id" = "$repo_basename" ] || [ "$skill_id" = "$name" ]; then
    entry=$(jq -n --arg name "$name" --arg desc "$desc" --arg src "$src_field" --argjson tags "$tags_json" \
      '{name: $name, description: $desc, source: $src, tags: $tags}')
  else
    entry=$(jq -n --arg name "$name" --arg desc "$desc" --arg src "$source" --arg skill "$skill_id" --argjson tags "$tags_json" \
      '{name: $name, description: $desc, source: $src, skill: $skill, tags: $tags}')
  fi

  new_entries=$(echo "$new_entries" | jq --argjson e "$entry" '. + [$e]')
done < <(echo "$validated_skills" | jq -r '.[] | [.name, .source, .skillId] | @tsv')

# --- Apply removals, then add newcomers to community.json ---
for f in $(cut -f1 "$removals" | sort -u); do
  names=$(awk -F'\t' -v f="$f" '$1 == f { print $2 }' "$removals" | jq -R . | jq -s '.')
  jq --argjson rm "$names" '[.[] | select(.name as $n | ($rm | index($n)) == null)]' "$f" > "$f.tmp"
  mv "$f.tmp" "$f"
  # The schema requires at least one entry per file; drop vendor files left empty.
  if [ "$f" != "$community_file" ] && [ "$(jq 'length' "$f")" -eq 0 ]; then
    rm "$f"
    echo "Removed $f (no entries left)"
  fi
done

jq --argjson new "$new_entries" '. + $new | sort_by(.name)' "$community_file" > "$community_file.tmp"
mv "$community_file.tmp" "$community_file"

echo "Synced: $validated_count added, $removed_count removed"

# --- Markdown summary for the PR body ---
if [ -n "$SUMMARY_FILE" ]; then
  {
    echo "## Summary"
    echo "Automated sync from skills.sh (all-time top $TOP_N + trending (24h) top $TRENDING_N) with audit scores and catalog update. **Please review before merging.**"
    echo ""
    echo "### Added ($validated_count)"
    echo "$validated_skills" | jq -r '.[] | "- `\(.name)` — `\(.source)` (\(.signal))"'
    echo ""
    echo "### Removed ($removed_count)"
    awk -F'\t' '{ printf "- `%s` (%s) — %s\n", $2, $1, $3 }' "$removals"
    echo ""
    echo "## Checklist"
    echo "- [ ] Review skill descriptions for accuracy"
    echo "- [ ] Review tag assignments"
    echo "- [ ] Check removals and duplicates"
  } > "$SUMMARY_FILE"
fi

# Rebuild hub JSON
./scripts/build.sh

echo ""
echo "Sync complete. Run 'make validate' to verify."
