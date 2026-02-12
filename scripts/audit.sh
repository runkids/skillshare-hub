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

  # Parse source into clone_url + optional subpath
  subpath=""
  if [[ "$source" =~ ^https?://github\.com/([^/]+/[^/]+)/tree/[^/]+/(.+)$ ]]; then
    # GitHub browser URL: https://github.com/owner/repo/tree/branch/path
    clone_url="https://github.com/${BASH_REMATCH[1]}.git"
    subpath="${BASH_REMATCH[2]}"
  elif [[ "$source" =~ ^https?://github\.com/([^/]+/[^/]+)/?$ ]]; then
    # GitHub repo URL (no subpath): https://github.com/owner/repo
    clone_url="https://github.com/${BASH_REMATCH[1]}.git"
  elif [[ "$source" =~ ^github\.com/([^/]+/[^/]+)(/(.+))?$ ]]; then
    # github.com shorthand: github.com/owner/repo[/path]
    clone_url="https://github.com/${BASH_REMATCH[1]}.git"
    subpath="${BASH_REMATCH[3]}"
  elif [[ "$source" =~ ^(https?://[^/]+)/([^/]+/[^/]+)/src/branch/[^/]+/(.+)$ ]]; then
    # Gitea/Forgejo browser URL: https://host/owner/repo/src/branch/main/path
    clone_url="${BASH_REMATCH[1]}/${BASH_REMATCH[2]}.git"
    subpath="${BASH_REMATCH[3]}"
  elif [[ "$source" =~ ^(https?://[^/]+)/([^/]+/[^/]+)/src/branch/ ]]; then
    # Gitea/Forgejo repo URL (branch root, no subpath)
    clone_url="${BASH_REMATCH[1]}/${BASH_REMATCH[2]}.git"
  elif [[ "$source" == http* ]]; then
    # Other HTTP URLs — use as-is
    clone_url="$source"
  else
    # GitHub shorthand: owner/repo[/path]
    owner_repo=$(echo "$source" | cut -d'/' -f1-2)
    subpath=$(echo "$source" | cut -d'/' -f3-)
    clone_url="https://github.com/${owner_repo}.git"
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

  # Audit subpath if specified, otherwise audit entire clone
  audit_target="$clone_dir"
  if [ -n "$subpath" ] && [ -d "$clone_dir/$subpath" ]; then
    audit_target="$clone_dir/$subpath"
  fi

  audit_json=$(skillshare audit "$audit_target" --threshold high --json 2>/dev/null) || true

  # Check if output is valid audit JSON
  if ! echo "$audit_json" | jq -e '.summary' >/dev/null 2>&1; then
    # Not valid JSON — command errored (e.g. path not found)
    audit_err=$(skillshare audit "$audit_target" --threshold high 2>&1) || true
    echo "$audit_err"
    results+=("| \`${source}\` | :x: Error | - |")
    details+=("DETAIL_SEP### \`${source}\`"$'\n'"\`\`\`"$'\n'"${audit_err}"$'\n'"\`\`\`")
    failed=1
    rm -rf "$clone_dir"
    log_endgroup
    continue
  fi

  # Extract risk info with jq
  risk_score=$(echo "$audit_json" | jq -r '.summary.riskScore')
  risk_label=$(echo "$audit_json" | jq -r '.summary.riskLabel' | tr '[:lower:]' '[:upper:]')
  risk="${risk_label} (${risk_score}/100)"

  # Format findings for display
  findings_text=$(echo "$audit_json" | jq -r '
    [.results[] | (.findings // [])[] | "  \(.severity): \(.message) (\(.file):\(.line))\n  \"\(.snippet)\""]
    | join("\n\n")')
  audit_display="Risk: ${risk}"
  [ -n "$findings_text" ] && audit_display="${audit_display}"$'\n\n'"${findings_text}"
  echo "$audit_display"

  if [[ "$risk_label" == "HIGH" || "$risk_label" == "CRITICAL" ]]; then
    results+=("| \`${source}\` | :x: Risk ${risk_label} | ${risk} |")
    details+=("DETAIL_SEP### \`${source}\`"$'\n'"\`\`\`"$'\n'"${audit_display}"$'\n'"\`\`\`")
    log_error "Risk ${risk_label} for ${source}"
    failed=1
  else
    results+=("| \`${source}\` | :white_check_mark: Passed | ${risk} |")
    details+=("DETAIL_SEP### \`${source}\`"$'\n'"\`\`\`"$'\n'"${audit_display}"$'\n'"\`\`\`")
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
