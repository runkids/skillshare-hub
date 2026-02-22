#!/usr/bin/env bash
set -euo pipefail

HUB_FILE="skillshare-hub.json"
README="README.md"

if [ ! -f "$HUB_FILE" ]; then
  echo "ERROR: $HUB_FILE not found. Run 'make build' first."
  exit 1
fi

if [ ! -f "$README" ]; then
  echo "ERROR: $README not found."
  exit 1
fi

# --- Category order and tag mapping ---
CATEGORIES="Frontend Marketing Workflow Agent Design Docs Testing Backend DevOps Security Other"

tag_to_category() {
  local tag="$1"
  case "$tag" in
    frontend|react|vue) echo "Frontend" ;;
    marketing|seo) echo "Marketing" ;;
    workflow|superpowers|git|skill|skillshare) echo "Workflow" ;;
    agent|ai|browser) echo "Agent" ;;
    design) echo "Design" ;;
    docs) echo "Docs" ;;
    testing|code-review) echo "Testing" ;;
    backend) echo "Backend" ;;
    devops) echo "DevOps" ;;
    security) echo "Security" ;;
    *) echo "" ;;
  esac
}

# --- Badge color mapping ---
badge_color() {
  case "$1" in
    clean) echo "brightgreen" ;;
    low) echo "green" ;;
    medium) echo "yellow" ;;
    high) echo "orange" ;;
    critical) echo "red" ;;
    *) echo "" ;;
  esac
}

# --- Build source URL ---
source_to_url() {
  local source="$1"
  if [[ "$source" == http* ]]; then
    echo "$source"
  else
    local owner_repo
    owner_repo=$(echo "$source" | cut -d'/' -f1-2)
    echo "https://github.com/${owner_repo}"
  fi
}

# --- Read skills and classify ---
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

# Initialize category files
for cat in $CATEGORIES; do
  touch "$tmp_dir/$cat"
done

jq -r '.skills[] | [.name, .description, .source, (.tags // [] | join(",")), (.riskLabel // "")] | @tsv' "$HUB_FILE" |
while IFS=$'\t' read -r name desc source tags risk_label; do
  [ -z "$name" ] && continue

  # Find category from first matching tag
  category=""
  IFS=',' read -ra tag_arr <<< "$tags"
  for tag in "${tag_arr[@]}"; do
    category=$(tag_to_category "$tag")
    [ -n "$category" ] && break
  done
  [ -z "$category" ] && category="Other"

  # Build markdown line
  url=$(source_to_url "$source")
  line="- [**${name}**](${url})"

  if [ -n "$risk_label" ]; then
    color=$(badge_color "$risk_label")
    line="${line} ![risk-${risk_label}](https://img.shields.io/badge/risk-${risk_label}-${color})"
  fi

  line="${line} — ${desc}"

  echo "$line" >> "$tmp_dir/$category"
done

# --- Generate catalog markdown to temp file ---
catalog_file="$tmp_dir/_catalog.md"
total=$(jq '.skills | length' "$HUB_FILE")
echo "**${total} skills** across $(echo $CATEGORIES | wc -w | tr -d ' ') categories — browse via \`skillshare search --hub\` or the Web UI" >> "$catalog_file"
echo "" >> "$catalog_file"

for cat in $CATEGORIES; do
  if [ -s "$tmp_dir/$cat" ]; then
    count=$(wc -l < "$tmp_dir/$cat" | tr -d ' ')
    echo "### ${cat} (${count})" >> "$catalog_file"
    echo "" >> "$catalog_file"
    echo "<details>" >> "$catalog_file"
    echo "<summary>Show ${count} skills</summary>" >> "$catalog_file"
    echo "" >> "$catalog_file"
    cat "$tmp_dir/$cat" >> "$catalog_file"
    echo "" >> "$catalog_file"
    echo "</details>" >> "$catalog_file"
    echo "" >> "$catalog_file"
  fi
done

# --- Insert into README between markers ---
if ! grep -q '<!-- CATALOG:START -->' "$README"; then
  echo "ERROR: <!-- CATALOG:START --> marker not found in $README"
  exit 1
fi

awk '
  /<!-- CATALOG:START -->/ {
    print
    while ((getline line < "'"$catalog_file"'") > 0) print line
    skip = 1
    next
  }
  /<!-- CATALOG:END -->/ {
    skip = 0
  }
  !skip { print }
' "$README" > "${README}.tmp" && mv "${README}.tmp" "$README"

skill_count=$(jq '.skills | length' "$HUB_FILE")
echo "Generated README catalog: $skill_count skills"
