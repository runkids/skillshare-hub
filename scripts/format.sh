#!/usr/bin/env bash
set -euo pipefail

SKILLS_DIR="${1:-skills}"

if [ ! -d "$SKILLS_DIR" ]; then
  echo "ERROR: $SKILLS_DIR directory not found"
  exit 1
fi

files=("$SKILLS_DIR"/*.json)
if [ ${#files[@]} -eq 0 ]; then
  echo "ERROR: No .json files found in $SKILLS_DIR"
  exit 1
fi

for f in "${files[@]}"; do
  jq 'sort_by(.name)' "$f" > "${f}.tmp" && mv "${f}.tmp" "$f"
done

count=$(jq -s '[.[][]] | length' "${files[@]}")
echo "Formatted: ${#files[@]} files ($count skills, sorted by name)"
