---
name: research
description: Investigate a question against high-trust primary sources and capture the findings as a Markdown file in the repo. Use when the user wants a topic researched, docs or API facts gathered, or reading legwork delegated to a background agent.
---

# Research

Spin up a **background agent** so you keep working while it reads. Delegate the *whole question*, not a slice of it: give the subagent a self-contained brief (the exact question, where the answer should land, and the citation bar) and let it run. Don't babysit it turn by turn.

## The agent's job

1. **Investigate the question against primary sources** — official docs, source code, specs, first-party APIs — not a secondary write-up of them. Follow every claim back to the source that owns it. *Done when:* every claim in the output resolves to a primary source the agent actually opened (not one it inferred from a headline).
2. **Write the findings to a single Markdown file**, citing each claim's source as a working link. Date the file and state the question it answers at the top, so the note is still readable (and trustable) months later. *Done when:* every claim carries a link, the file opens in a browser, and open questions are explicitly marked as unanswered rather than glossed over.
3. **Save it where the repo already keeps such notes.** Match the existing convention; if there is none, put it somewhere sensible and say where. *Done when:* the location either matches the repo convention or is announced in the reply.

## Process

- **Find the convention first.** Before writing anywhere, look for an existing notes/docs structure (`docs/`, `research/`, a knowledge base the repo points to). Dropping the note at the root when `docs/research/` exists is a failure of this step, not a preference.
- **Separate fact from uncertainty.** When a source is unclear, conflicting, or out of date, state the tension in the note instead of picking a winner silently. The agent's job is to surface the truth it could reach, qualified, not to guess.
- **Say where it landed.** If you picked a location, name it in your reply so the user can find the note without hunting.

## Verification (before you report done)

- Spot-check 2–3 citations: re-open them and confirm each supports the adjacent claim.
- Confirm every `[link](...)` in the note is a real, reachable URL — no placeholders or copy-paste anchors.
- Confirm unanswered sub-questions are listed as such, not folded into an answer the sources don't actually give.

## Pitfalls

- **Secondary drift**: a blog post paraphrasing an outdated API. Primary wins; say when a secondary source is the only one available.
- **Convention mismatch**: the note dropped at the repo root when `docs/research/` exists. Explore the repo before choosing a location.
- **Assertion without a source**: a confident statement the agent can't trace. Not allowed in the note.
- **Stale by design**: check the publication/commit date of each source and note when a fact is known to decay (version numbers, deprecations), so the reader knows what to re-verify.