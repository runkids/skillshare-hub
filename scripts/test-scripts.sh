#!/usr/bin/env bash
set -euo pipefail

# Self-check for the source parsing shared by audit.sh and audit-all.sh.
# Loads each script's parse_source() without running the script, then checks
# that every source form maps to the expected clone URL and subpath.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cases=(
  # source|clone_url|subpath
  "owner/repo|https://github.com/owner/repo.git|"
  "owner/repo/my-skill|https://github.com/owner/repo.git|my-skill"
  "https://github.com/owner/repo/tree/main/skills/x|https://github.com/owner/repo.git|skills/x"
  "https://gitlab.com/team/deploy-guard|https://gitlab.com/team/deploy-guard|"
  "git@git.company.com:platform/ai-skills.git//skills/reviewer|git@git.company.com:platform/ai-skills.git|skills/reviewer"
  "git@git.company.com:platform/ai-skills.git|git@git.company.com:platform/ai-skills.git|"
  "ssh://git@git.company.com:2222/platform/ai-skills.git//skills/reviewer|ssh://git@git.company.com:2222/platform/ai-skills.git|skills/reviewer"
  "ssh://git@git.company.com/platform/ai-skills.git|ssh://git@git.company.com/platform/ai-skills.git|"
)

failed=0
for script in audit.sh audit-all.sh; do
  eval "$(sed -n '/^parse_source() {/,/^}/p' "$SCRIPT_DIR/$script")"
  for c in "${cases[@]}"; do
    IFS='|' read -r source want_url want_sub <<< "$c"
    got=$(parse_source "$source")
    want=$(printf '%s\t%s' "$want_url" "$want_sub")
    if [ "$got" != "$want" ]; then
      echo "FAIL: $script parse_source '$source'"
      echo "  want: $want"
      echo "  got:  $got"
      failed=1
    fi
  done
  unset -f parse_source
done

if [ "$failed" -ne 0 ]; then
  exit 1
fi
echo "OK: parse_source (${#cases[@]} cases × 2 scripts)"
