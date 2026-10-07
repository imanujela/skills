---
name: handoff
description: Compact the current conversation into a handoff document for another agent to pick up.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

Write a handoff document summarising the current conversation so a fresh, zero-context agent can continue the work — current state, next step, and every open thread present, with nothing left for the new agent to re-ask a question this conversation already answered. Save it to the temporary directory of the user's OS (`$TMPDIR`, else `/tmp`; `%TEMP%` on Windows), never the current workspace, and report the exact path.

Include a **"suggested skills"** section naming which skills the next agent should call the Skill tool for — every capability the next session needs that a skill covers.

Do not duplicate content already captured in other artifacts (specs, plans, ADRs, issues, commits, diffs). Reference them by path or URL instead, so the handoff cannot go stale as those artifacts change.

Redact any sensitive information — API keys, passwords, credentials, personally identifiable information — before writing, and scan the finished document once over for strays.

If the user passed arguments, treat them as a description of what the next session will focus on and tailor the whole document to that focus.

## Verification

- The file exists in the OS temp dir (not the workspace); its exact path was reported.
- A zero-context reader can resume from it: state, next step, and open threads all present.
- No artifact content is restated; every reference is a path or URL only.
- A scan finds no secrets, tokens, or PII; the "suggested skills" section is present.
- Every named focus from the user's arguments is reflected in the document.

## Pitfalls

- **Saving into the workspace**, where the handoff can be lost to a commit, a clean, or the project itself.
- **Summarising the conversation's history** instead of its state; the successor needs the current position, not a recounting.
- **Restating spec or diff content** instead of linking it, so the handoff silently drifts from the artifacts it summarizes.
- **Leaking secrets via a broad summary**: writing the whole conversation verbatim instead of the distilled state.