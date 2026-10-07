---
name: claude-handoff
description: Hand the current conversation off to a fresh background agent that picks up the work immediately.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

Write a handoff summary of the current conversation so a fresh agent can continue the work. Save it to the temporary directory of the user's OS, then launch a background agent seeded with it as its prompt:

```
claude --bg --name "<descriptive name>" -- "$(cat <summary file>)"
```

Passing the file (rather than inlining its contents) keeps the shell from running backticks or expanding `$` in the summary. The agent starts in the current working directory and returns immediately; the user manages it with `claude agents`.

Always pass `-n`/`--name` with a descriptive name (e.g. `--name "Fix login bug"`); it sets the display name shown in the job list, session picker, and terminal title.

## What the summary must contain

- **Where the work stands** — current state, what's done, what's left.
- **The immediate next action** — the very first thing the fresh agent should do.
- **A "suggested skills" section** — naming which skills the next agent should call the Skill tool for.
- **Reference pointers, not content.** Do not duplicate material already captured in other artifacts (specs, plans, ADRs, issues, commits, diffs). Reference them by path or URL instead.
- **Context the next agent cannot fetch itself** — any environment detail, constraints, or decisions that aren't recorded elsewhere.

## Rules

- **Redact sensitive information.** The summary becomes the agent's prompt, so strip API keys, passwords, and personally identifiable information.
- **Tailor to the arguments.** If the user passed arguments, treat them as a description of what the next session will focus on and shape the summary accordingly.
- **Keep it tight.** The fresh agent inherits your context budget; a bloated handoff wastes it.

## WIP framing (in progress)

This skill's success hinges on the quality of the handoff artifact. If the handoff is vague, the fresh agent will re-derive context you already had. If it is bloated, it eats the new agent's budget. The craft is compression: dense, pointer-heavy, and actionable.

## Verification checklist

- [ ] Summary file exists in the OS temp directory
- [ ] Contains: current state, next action, "suggested skills" section, and artifact pointers
- [ ] Sensitive data removed
- [ ] Background agent launched with a descriptive `--name`
- [ ] The summary file path was passed (not inlined) to avoid shell expansion

## Pitfalls

- **Never inline the summary into the command string.** Backticks and `$` in the content would be executed by the shell. Always `$(cat <file>)`.
- **A generic `--name` like "handoff" is useless.** Name it for the work, so `claude agents` is legible later.
- **Don't paste artifacts you can point to.** Re-copying a whole spec into the summary is wasted budget and a drift risk — link it.
- **Sanitize before you save.** Assume the temp file may outlive the conversation.