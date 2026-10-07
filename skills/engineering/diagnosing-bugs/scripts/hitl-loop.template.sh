#!/usr/bin/env bash
# ============================================================================
# hitl-loop.template.sh — Human-in-the-loop reproduction loop
#
# PURPOSE
#   Gives a debugging agent a *structured* loop when the bug can only be
#   reproduced by a human clicking in a UI. The agent runs this script; the
#   user follows the prompts in their terminal; captured observations are
#   printed at the end as KEY=VALUE lines the agent can parse.
#
# USAGE
#   1. Copy this file to a scratch location (do not commit the edited copy).
#   2. Edit ONLY the "edit below" section: replace the sample steps/captures
#      with the minimal sequence that triggers the bug.
#   3. Run:  bash hitl-loop.template.sh   (or your edited copy)
#   4. Parse the final "--- Captured ---" block for the observed values.
#
# HELPERS (do not edit)
#   step   "<instruction>"      -> show instruction, wait for Enter
#   capture VAR   "<question>"  -> show question, read answer into VAR
#
# DESIGN NOTES
#   - `capture` echoes its value back so the agent reading the terminal sees
#     the observation. Use `capture` for observations; leave sign-ins/logins
#     to the user as a `step` (never capture credentials into the log).
#   - Every captured KEY=VALUE line is safe to paste back to the agent ONLY
#     if no question asked for a secret — keep it that way.
# ============================================================================
set -euo pipefail

# --- Hardening --------------------------------------------------------------
# Under `set -u` a typo'd CAPTURED var name aborts with a clear message
# instead of silently capturing nothing; the EXIT trap explains the abort and
# points out that already-printed captures are still usable.
_CAPTURED_COUNT=0
trap 'rc=$?; if (( rc != 0 )); then printf "\n[HITL] Aborted early (exit %s). Partial captures above are still usable; re-run from the top.\n" "$rc" >&2; fi' EXIT

step() {
  # Show an instruction to the human and block until they confirm done.
  printf '\n>>> %s\n' "$1"
  read -r -p "    [Enter when done] " _
}

capture() {
  # Ask a question, store the answer in VAR, echo it for the agent.
  local var="$1" question="$2" answer
  printf '\n>>> %s\n' "$question"
  read -r -p "    > " answer
  printf -v "$var" '%s' "$answer"
  _CAPTURED_COUNT=$(( _CAPTURED_COUNT + 1 ))
}

# --- edit below: replace with YOUR reproduction steps ----------------------

step "Open the app at http://localhost:3000 and sign in."

capture ERRORED "Click the 'Export' button. Did it throw an error? (y/n)"

capture ERROR_MSG "Paste the error message (or 'none'):"

# --- edit above -------------------------------------------------------------

# Completion block: print every captured variable as KEY=VALUE, one per line.
# The agent parses THIS section; keep variable names stable once a loop is
# being consumed so the parser doesn't break between runs.
printf '\n--- Captured ---\n'
printf 'ERRORED=%s\n' "$ERRORED"
printf 'ERROR_MSG=%s\n' "$ERROR_MSG"
printf '[HITL] Loop complete: %d values captured.\n' "$_CAPTURED_COUNT"
exit 0
