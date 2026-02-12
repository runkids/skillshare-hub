#!/usr/bin/env bash
set -euo pipefail

SKILLS_DIR="${1:-skills}"
HUB_FILE="skillshare-hub.json"

if [ ! -d "$SKILLS_DIR" ]; then
  echo "ERROR: $SKILLS_DIR directory not found"
  exit 1
fi

# Count source files
files=("$SKILLS_DIR"/*.json)
if [ ${#files[@]} -eq 0 ]; then
  echo "ERROR: No .json files found in $SKILLS_DIR"
  exit 1
fi

# Merge all arrays, sort by name, wrap in hub schema
jq -s '{
  schemaVersion: 1,
  skills: ([.[][]] | sort_by(.name))
}' "${files[@]}" > "$HUB_FILE"

count=$(jq '.skills | length' "$HUB_FILE")
echo "Built: $HUB_FILE ($count skills from ${#files[@]} files)"
