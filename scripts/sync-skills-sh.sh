#!/usr/bin/env bash
set -euo pipefail

# Sync top skills from skills.sh into the hub.
# Fetches the leaderboard, diffs against existing skills, generates new entries,
# and writes them to skills/community.json (or owner-specific files).
#
# Usage: ./scripts/sync-skills-sh.sh [--top N] [--dry-run]

TOP_N=200
DRY_RUN=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --top) TOP_N="$2"; shift 2 ;;
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

# --- Fetch skills.sh leaderboard ---
echo "Fetching top $TOP_N skills from skills.sh..."

html=$(curl -fsSL "https://skills.sh/" 2>/dev/null) || {
  echo "ERROR: Failed to fetch skills.sh"
  exit 1
}

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
    const match = html.match(/self\.__next_f\.push\(\[1,\"(.*?initialSkills.*?)\"\]\)/s);
    if (!match) { process.exit(1); }
    const inner = JSON.parse('\"' + match[1] + '\"');
    const idx = inner.indexOf('\"initialSkills\":');
    const arrStart = idx + '\"initialSkills\":'.length;
    let depth = 0, i = arrStart;
    for (; i < inner.length; i++) {
      if (inner[i] === '[') depth++;
      else if (inner[i] === ']') { depth--; if (depth === 0) break; }
    }
    console.log(inner.substring(arrStart, i + 1));
  " <<< "$html") || {
    echo "ERROR: Failed to parse skills.sh data. Page format may have changed."
    exit 1
  }
fi

fetched_count=$(echo "$skills_json" | jq 'length')
echo "Fetched $fetched_count skills from skills.sh"

# Take top N
top_skills=$(echo "$skills_json" | jq --argjson n "$TOP_N" '.[:$n]')

# --- Diff against existing hub ---
existing_names=$(jq -r '[.skills[].name] | .[]' "$HUB_FILE" | sort -u)

# Deduplicate by name (keep first = higher ranked), exclude existing, filter invalid names
new_skills=$(echo "$top_skills" | jq --argjson existing "$(echo "$existing_names" | jq -R . | jq -s .)" '
  [.[] |
    select(.name | test("^[a-z0-9][a-z0-9-]*$")) |
    select(.name as $n | ($existing | index($n)) == null)
  ] |
  reduce .[] as $item ({}; if .[$item.name] then . else . + {($item.name): $item} end) |
  [.[]] | sort_by(.name)
')

new_count=$(echo "$new_skills" | jq 'length')

if [ "$new_count" -eq 0 ]; then
  echo "No new skills to add. Hub is up to date."
  exit 0
fi

echo "Found $new_count new skills to add"

if [ "$DRY_RUN" = true ]; then
  echo ""
  echo "=== DRY RUN — would add these skills ==="
  echo "$new_skills" | jq -r '.[] | "  \(.name) (\(.source))"'
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

# --- Generate entries and write to community.json ---
# New skills go to skills/community.json (catch-all for auto-synced)
community_file="$SKILLS_DIR/community.json"

# Build new entries
new_entries="[]"

while IFS=$'\t' read -r name source skill_id; do
  [ -z "$name" ] && continue

  desc=$(infer_description "$name" "$source")
  tags_csv=$(infer_tags "$name" "$source")

  # Build source field: owner/repo/skillId for multi-skill repos
  src_field="$source/$skill_id"

  # Build tags array
  tags_json=$(echo "$tags_csv" | tr ',' '\n' | jq -R . | jq -s '.')

  # Build entry (with skill field if skillId != repo basename)
  repo_basename=$(basename "$source")
  if [ "$skill_id" = "$repo_basename" ] || [ "$skill_id" = "$name" ]; then
    entry=$(jq -n --arg name "$name" --arg desc "$desc" --arg src "$src_field" --argjson tags "$tags_json" \
      '{name: $name, description: $desc, source: $src, tags: $tags}')
  else
    entry=$(jq -n --arg name "$name" --arg desc "$desc" --arg src "$source" --arg skill "$skill_id" --argjson tags "$tags_json" \
      '{name: $name, description: $desc, source: $src, skill: $skill, tags: $tags}')
  fi

  new_entries=$(echo "$new_entries" | jq --argjson e "$entry" '. + [$e]')
done < <(echo "$new_skills" | jq -r '.[] | [.name, .source, .skillId] | @tsv')

# Merge into community.json
existing=$(cat "$community_file")
merged=$(echo "$existing" | jq --argjson new "$new_entries" '. + $new | sort_by(.name)')
echo "$merged" | jq '.' > "$community_file"

echo "Added $new_count skills to $community_file"

# Rebuild hub JSON
./scripts/build.sh

echo ""
echo "Sync complete. Run 'make validate' to verify."
