#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
SKILLS_DIR="${1:-skills}"
CATEGORY_SCHEMA="$ROOT_DIR/schemas/skill-category.schema.json"

if [ ! -d "$SKILLS_DIR" ]; then
  echo "ERROR: $SKILLS_DIR directory not found"
  exit 1
fi

files=("$SKILLS_DIR"/*.json)
if [ ${#files[@]} -eq 0 ]; then
  echo "ERROR: No .json files found in $SKILLS_DIR"
  exit 1
fi

# Check valid JSON for each category file
for f in "${files[@]}"; do
  if ! jq empty "$f" 2>/dev/null; then
    echo "ERROR: Invalid JSON in $f"
    exit 1
  fi
done
echo "OK: valid JSON (${#files[@]} files)"

# Schema validation (category files)
if [ -f "$CATEGORY_SCHEMA" ] && command -v npx &>/dev/null; then
  schema_fail=0
  for f in "${files[@]}"; do
    if ! npx --yes ajv-cli@5 validate -s "$CATEGORY_SCHEMA" -d "$f" --spec=draft2020 2>/dev/null; then
      echo "ERROR: $f does not match schema"
      schema_fail=1
    fi
  done
  if [ "$schema_fail" -eq 1 ]; then
    exit 1
  fi
  echo "OK: schema valid"
else
  echo "SKIP: schema validation (ajv-cli not available)"
fi

# Merge all category files for cross-file checks
merged=$(jq -s '[.[][]]' "${files[@]}")

# Check required fields
missing=$(echo "$merged" | jq -r '.[] | select(.name == "" or .name == null or .description == "" or .description == null or .source == "" or .source == null) | .name // "unnamed"')
if [ -n "$missing" ]; then
  echo "ERROR: Skills missing required fields: $missing"
  exit 1
fi
echo "OK: required fields present"

# Check no duplicate names
dupes=$(echo "$merged" | jq -r '[.[].name] | group_by(.) | map(select(length > 1)) | flatten | .[]')
if [ -n "$dupes" ]; then
  echo "ERROR: Duplicate skill names: $dupes"
  exit 1
fi
echo "OK: no duplicate names"

# Check no duplicate sources (source + skill combo)
dupe_sources=$(echo "$merged" | jq -r '[.[] | (.source + if .skill then "/" + .skill else "" end)] | group_by(.) | map(select(length > 1)) | flatten | unique | .[]')
if [ -n "$dupe_sources" ]; then
  echo "ERROR: Duplicate skill sources: $dupe_sources"
  exit 1
fi
echo "OK: no duplicate sources"

# Check name format (lowercase, hyphens only)
bad_names=$(echo "$merged" | jq -r '.[].name | select(test("^[a-z0-9][a-z0-9-]*$") | not)')
if [ -n "$bad_names" ]; then
  echo "ERROR: Invalid skill names (must be lowercase, hyphens): $bad_names"
  exit 1
fi
echo "OK: name format valid"

# Check each file is sorted by name
for f in "${files[@]}"; do
  expected=$(jq 'sort_by(.name)' "$f")
  actual=$(cat "$f")
  if [ "$expected" != "$actual" ]; then
    echo "ERROR: $f is not sorted by name. Run: make format"
    exit 1
  fi
done
echo "OK: formatting correct"

count=$(echo "$merged" | jq 'length')
echo ""
echo "Validation passed: $count skills from ${#files[@]} files"
