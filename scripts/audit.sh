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
results=()
details=()

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

  if ! clone_output=$(git clone --depth 1 "$clone_url" "$clone_dir" 2>&1); then
    log_error "Failed to clone ${source}"
    results+=("| \`${source}\` | :x: Clone failed | - |")
    details+=("DETAIL_SEP### \`${source}\`"$'\n'"Clone failed:"$'\n'"\`\`\`"$'\n'"${clone_output}"$'\n'"\`\`\`")
    failed=1
    log_endgroup
    continue
  fi

  audit_output=$(skillshare audit "$clone_dir" --threshold high 2>&1 | sed 's/\x1b\[[0-9;]*m//g') || true

  echo "$audit_output"

  # Extract risk score and label
  risk=$(echo "$audit_output" | sed -n 's/.*Risk: \([A-Z]* ([0-9]*\/[0-9]*)\).*/\1/p' | tail -1)
  [ -z "$risk" ] && risk="N/A"
  risk_label=$(echo "$risk" | awk '{print $1}')

  if echo "$audit_output" | grep -q "config not found"; then
    results+=("| \`${source}\` | :x: No config | - |")
    details+=("DETAIL_SEP### \`${source}\`"$'\n'"No skillshare config found. Run \`skillshare init\` in the source repo.")
    log_error "No skillshare config found for ${source}. Run 'skillshare init' in the source repo."
    failed=1
  elif [[ "$risk_label" == "HIGH" || "$risk_label" == "CRITICAL" ]]; then
    results+=("| \`${source}\` | :x: Risk ${risk_label} | ${risk} |")
    details+=("DETAIL_SEP### \`${source}\`"$'\n'"\`\`\`"$'\n'"${audit_output}"$'\n'"\`\`\`")
    log_error "Risk ${risk_label} for ${source}"
    failed=1
  else
    results+=("| \`${source}\` | :white_check_mark: Passed | ${risk} |")
    details+=("DETAIL_SEP### \`${source}\`"$'\n'"\`\`\`"$'\n'"${audit_output}"$'\n'"\`\`\`")
  fi

  rm -rf "$clone_dir"
  log_endgroup
done <<< "$new_sources"

# --- Generate report ---
if [ -n "$REPORT_FILE" ]; then
  {
    echo "## Skill Audit Results"
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
