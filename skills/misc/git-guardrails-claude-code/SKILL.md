---
name: git-guardrails-claude-code
description: Set up Claude Code hooks to block dangerous git commands (push, reset --hard, clean, branch -D, etc.) before they execute. Use when user wants to prevent destructive git operations, add git safety hooks, or block git push/reset in Claude Code.
---

# Setup Git Guardrails

A PreToolUse hook that intercepts and blocks dangerous git commands **before** Claude executes them. Hardened for reliability (fail-open) so the guard itself can never wedge ordinary Bash work.

## The hook contract (read this first)

The bundled script, [`scripts/block-dangerous-git.sh`](scripts/block-dangerous-git.sh), reads a `PreToolUse` JSON event on stdin and signals the verdict to Claude Code with its **exit code**:

- `exit 2` → **block** the tool call. Claude sees whatever the script wrote to stderr.
- `exit 0` → **allow** the command through.

The script is **fail-open by design**: any inability to inspect the command (missing `jq`, malformed payload, an unexpected error) exits 0 and lets the command run. A broken guard must never silently block every Bash call — the cost of a rare missed guardrail is far lower than the cost of a guard that breaks the user's terminal. Do not "harden" this away by flipping it fail-closed.

## What gets blocked

- `git push` — all variants, including `--force`
- `git reset --hard`
- `git clean -f` / `git clean -fd`
- `git branch -D`
- `git checkout .` / `git restore .`
- `push --force` and `reset --hard` (so the guard still fires even when a command omits the `git` prefix)

When blocked, Claude sees a message telling it it does not have authority to run the command.

## Steps

### 1. Ask scope

Ask the user: install for **this project only** (`.claude/settings.json`) or **all projects** (`~/.claude/settings.json`).

**Done when:** the user has picked a scope. Default to project-only if they are unsure — it is reversible and touches nothing global.

### 2. Copy the hook script

Copy [`scripts/block-dangerous-git.sh`](scripts/block-dangerous-git.sh) to the target location based on scope, then make it executable:

- **Project**: `.claude/hooks/block-dangerous-git.sh`
- **Global**: `~/.claude/hooks/block-dangerous-git.sh`

```
chmod +x <target-path>
```

**Done when:** the file exists at the target path and `chmod +x` succeeds. Verify executable bits with `ls -l` before moving on.

### 3. Add hook to settings

Add to the appropriate settings file:

**Project** (`.claude/settings.json`):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

**Global** (`~/.claude/settings.json`):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

**Merge, never overwrite.** If the settings file already exists, add the hook into the existing `hooks.PreToolUse` array. Preserve every other key. Then validate the resulting JSON (`jq . <file>` or `python -m json.tool`).

**Done when:** the settings file is valid JSON and contains the new hook without losing any pre-existing settings.

### 4. Ask about customization

Ask whether the user wants to add or remove any patterns from the blocked list, and edit the copied script's `DANGEROUS_PATTERNS` array accordingly. Keep each entry a plain regex substring the way the existing ones are — do not introduce shell metacharacters that need escaping.

**Done when:** the user has confirmed the blocked list (or explicitly declined to change it).

### 5. Verify

Run a block test — must `exit 2` with a BLOCKED message on stderr:

```bash
echo '{"tool_input":{"command":"git push origin main"}}' | <path-to-script>
echo "exit code: $?"   # expect 2
```

Then an allow test with a benign command — must `exit 0` with no BLOCKED output:

```bash
echo '{"tool_input":{"command":"git status"}}' | <path-to-script>
echo "exit code: $?"   # expect 0
```

**Done when:** the dangerous command exits 2 with a BLOCKED message and `git status` exits 0. Confirm both before finishing.

## Verification checklist

- [ ] Hook script exists at the chosen location and is executable (`ls -l`)
- [ ] Settings JSON parses and contains the `PreToolUse` hook; merge preserved old settings
- [ ] A dangerous command input exits 2 with a BLOCKED message on stderr
- [ ] A harmless command like `git status` still passes through (exit 0)

## Pitfalls

- **Merging matters.** Overwriting an existing settings file silently disables the user's other hooks.
- **Exit code matters.** The hook must exit **2** to block. Exit 1 or 0 lets the command through — Claude Code only treats code 2 as an explicit block.
- **Fail-open is intentional.** If `jq` is not installed the script lets commands through rather than blocking everything. Install `jq` on the user's machine if you want full coverage.
- **Customization drifts.** If the user asks to remove a pattern, update the copied script — not just the source — or the guard silently stops guarding that command.
- **Quoting.** Keep the `command` string exactly as shown; the `\"$CLAUDE_PROJECT_DIR\"` quoting is what makes the hook resolve paths on machines where the project dir contains spaces.