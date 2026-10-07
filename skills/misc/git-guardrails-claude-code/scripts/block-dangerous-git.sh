#!/bin/bash
# =============================================================================
# block-dangerous-git.sh — Claude Code PreToolUse hook.
#
# HOOK CONTRACT
#   stdin : one PreToolUse JSON event, e.g.
#           {"tool_input":{"command":"git push origin main"}}
#   exit 2 : BLOCK the Bash tool call (stderr is surfaced to Claude)
#   exit 0 : ALLOW the Bash tool call
#
# FAIL-OPEN BY DESIGN
#   Any inability to inspect the command — missing jq, malformed payload, or an
#   unexpected error — must exit 0 and LET the command through. A broken guard
#   must never silently block innocent Bash calls. Do not "harden" this into
#   fail-closed; the rare missed guardrail is cheaper than a wedged terminal.
#
# INSTALL / REGISTER (see skills/misc/git-guardrails-claude-code/SKILL.md)
#   project: copy to .claude/hooks/    global: copy to ~/.claude/hooks/
#   chmod +x the copy, then add a PreToolUse hook with matcher "Bash".
#
# MANUAL TEST
#   echo '{"tool_input":{"command":"git push origin main"}}' | bash block-dangerous-git.sh
#   # -> exits 2, prints BLOCKED to stderr
#   printf '%s\n' '{"tool_input":{"command":"git status"}}' | bash block-dangerous-git.sh
#   # -> exits 0, silent
# =============================================================================
set -euo pipefail

# Any unexpected error while inspecting -> FAIL OPEN (exit 0, allow). Turning off
# the trap first prevents re-entry when we exit from inside the handler.
trap 'trap - ERR; echo "block-dangerous-git: guard failed unexpectedly; allowing" >&2; exit 0' ERR

# One regex per line. Patterns are deliberately overlapping substrings so that
# variants (--force, quoted flags, abbreviated aliases) are caught by a shared
# fragment. Escaping matches how they appear in a real command line.
DANGEROUS_PATTERNS=(
  "git push"
  "git reset --hard"
  "git clean -fd"
  "git clean -f"
  "git branch -D"
  "git checkout \."
  "git restore \."
  "push --force"
  "reset --hard"
)

# Fail open: print a diagnostic and let the command through.
fail_open() {
  echo "block-dangerous-git: $* (allowing)" >&2
  exit 0
}

# Block with the exit code 2 the hook contract requires.
block() {
  local command="$1" pattern="$2"
  echo "BLOCKED: '$command' matches dangerous pattern '$pattern'. The user has prevented you from doing this." >&2
  exit 2
}

main() {
  # jq is the only external dependency beyond coreutils. Without it we cannot
  # safely pull the command out of the JSON, so fail open rather than guess.
  command -v jq >/dev/null 2>&1 || fail_open "jq not found; cannot inspect command"

  local input command
  input="$(cat)"
  command="$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null || true)"

  # No command to inspect (empty or malformed payload) -> allow.
  if [[ -z "$command" ]]; then
    exit 0
  fi

  local pattern
  for pattern in "${DANGEROUS_PATTERNS[@]}"; do
    # Guarded by `if` so a no-match (grep exit 1) is ordinary control flow,
    # not an error that trips `set -e` / the ERR trap.
    if printf '%s' "$command" | grep -qE "$pattern"; then
      block "$command" "$pattern"
    fi
  done
}

main
exit 0