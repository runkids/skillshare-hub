#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
HUB_FILE="${1:-skillshare-hub.json}"
SKILLS_DIR="${2:-skills}"
HUB_SCHEMA="$ROOT_DIR/schemas/skillshare-hub.schema.json"
CATEGORY_SCHEMA="$ROOT_DIR/schemas/skill-category.schema.json"

if [ ! -f "$HUB_FILE" ]; then
  echo "ERROR: $HUB_FILE not found"
  exit 1
fi

# Check valid JSON
if ! jq empty "$HUB_FILE" 2>/dev/null; then
  echo "ERROR: Invalid JSON in $HUB_FILE"
  exit 1
fi
echo "OK: valid JSON"

# Schema validation (hub file)
if [ -f "$HUB_SCHEMA" ] && command -v npx &>/dev/null; then
  if npx --yes ajv-cli@5 validate -s "$HUB_SCHEMA" -d "$HUB_FILE" --spec=draft2020 2>/dev/null; then
    echo "OK: hub schema valid"
  else
    echo "ERROR: $HUB_FILE does not match schema"
    exit 1
  fi
else
  echo "SKIP: schema validation (ajv-cli not available)"
fi

# Schema validation (category files)
if [ -d "$SKILLS_DIR" ] && [ -f "$CATEGORY_SCHEMA" ] && command -v npx &>/dev/null; then
  schema_fail=0
  for f in "$SKILLS_DIR"/*.json; do
    if ! npx --yes ajv-cli@5 validate -s "$CATEGORY_SCHEMA" -d "$f" --spec=draft2020 2>/dev/null; then
      echo "ERROR: $f does not match schema"
      schema_fail=1
    fi
  done
  if [ "$schema_fail" -eq 1 ]; then
    exit 1
  fi
  echo "OK: category schemas valid"
else
  echo "SKIP: category schema validation"
fi

# Check required fields
missing=$(jq -r '.skills[] | select(.name == "" or .name == null or .description == "" or .description == null or .source == "" or .source == null) | .name // "unnamed"' "$HUB_FILE")
if [ -n "$missing" ]; then
  echo "ERROR: Skills missing required fields: $missing"
  exit 1
fi
echo "OK: required fields present"

# Check no duplicate names
dupes=$(jq -r '[.skills[].name] | group_by(.) | map(select(length > 1)) | flatten | .[]' "$HUB_FILE")
if [ -n "$dupes" ]; then
  echo "ERROR: Duplicate skill names: $dupes"
  exit 1
fi
echo "OK: no duplicate names"

# Check no duplicate sources (source + skill combo)
dupe_sources=$(jq -r '[.skills[] | (.source + if .skill then "/" + .skill else "" end)] | group_by(.) | map(select(length > 1)) | flatten | unique | .[]' "$HUB_FILE")
if [ -n "$dupe_sources" ]; then
  echo "ERROR: Duplicate skill sources: $dupe_sources"
  exit 1
fi
echo "OK: no duplicate sources"

# Check name format (lowercase, hyphens only)
bad_names=$(jq -r '.skills[].name | select(test("^[a-z0-9][a-z0-9-]*$") | not)' "$HUB_FILE")
if [ -n "$bad_names" ]; then
  echo "ERROR: Invalid skill names (must be lowercase, hyphens): $bad_names"
  exit 1
fi
echo "OK: name format valid"

# Check formatting (sorted by name, jq default 2-space indent)
expected=$(jq '.skills |= sort_by(.name)' "$HUB_FILE")
actual=$(cat "$HUB_FILE")
if [ "$expected" != "$actual" ]; then
  echo "ERROR: $HUB_FILE is not formatted. Run: make format"
  exit 1
fi
echo "OK: formatting correct"

echo ""
echo "Validation passed: $(jq '.skills | length' "$HUB_FILE") skills"
