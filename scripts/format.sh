#!/usr/bin/env bash
set -euo pipefail

HUB_FILE="${1:-skillshare-hub.json}"

if [ ! -f "$HUB_FILE" ]; then
  echo "ERROR: $HUB_FILE not found"
  exit 1
fi

jq '.skills |= sort_by(.name)' "$HUB_FILE" > "${HUB_FILE}.tmp" \
  && mv "${HUB_FILE}.tmp" "$HUB_FILE"

echo "Formatted: $HUB_FILE ($(jq '.skills | length' "$HUB_FILE") skills, sorted by name)"
