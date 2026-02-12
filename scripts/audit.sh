#!/usr/bin/env bash
set -euo pipefail

HUB_FILE="skillshare-hub.json"
BASE_REF="${1:-${BASE_SHA:-main}}"

# Detect environment
is_ci() { [ "${CI:-}" = "true" ]; }
log_group() { is_ci && echo "::group::$1" || echo "=== $1 ==="; }
log_endgroup() { is_ci && echo "::endgroup::" || true; }
log_error() { is_ci && echo "::error::$1" || echo "ERROR: $1"; }

# --- Find new/changed sources ---
base_sources=$(git show "${BASE_REF}:${HUB_FILE}" 2>/dev/null \
  | jq -r '.skills[] | "\(.name)|\(.source)"' | sort) || base_sources=""

pr_sources=$(jq -r '.skills[] | "\(.name)|\(.source)"' "$HUB_FILE" | sort)

new_sources=$(comm -13 <(echo "$base_sources") <(echo "$pr_sources") | cut -d'|' -f2)

if [ -z "$new_sources" ]; then
  echo "No new or changed skill sources to audit"
  exit 0
fi

echo "New/changed sources to audit:"
echo "$new_sources"
echo ""

# --- Check skillshare is available ---
if ! command -v skillshare &>/dev/null; then
  echo "ERROR: skillshare CLI not found. Install from https://github.com/runkids/skillshare"
  exit 1
fi

# --- Audit each source ---
failed=0
while IFS= read -r source; do
  [ -z "$source" ] && continue

  if [[ "$source" == http* ]]; then
    clone_url="$source"
  else
    clone_url="https://github.com/${source}.git"
  fi

  safe_name=$(echo "$source" | tr '/' '-')
  clone_dir="/tmp/audit-${safe_name}"

  log_group "Auditing ${source}"

  if ! git clone --depth 1 "$clone_url" "$clone_dir" 2>&1; then
    log_error "Failed to clone ${source}"
    failed=1
    log_endgroup
    continue
  fi

  if ! skillshare audit "$clone_dir" --threshold high; then
    log_error "Security audit failed for ${source}"
    failed=1
  fi

  rm -rf "$clone_dir"
  log_endgroup
done <<< "$new_sources"

if [ "$failed" -ne 0 ]; then
  echo ""
  log_error "One or more skills failed the security audit. Please fix the flagged issues and push again."
  exit 1
fi

echo "All new skills passed the security audit"
