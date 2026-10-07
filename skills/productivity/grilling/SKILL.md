---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview the user relentlessly until you reach a shared understanding. Model the discussion as a **design tree**: every decision branches into the further decisions that hang off it, and the session is complete only when every branch is resolved.

## Rounds and the frontier

Work the tree in **rounds**. In any round, the **frontier** is the set of decisions whose prerequisites are already settled — the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the entire frontier in one round: number each question and put your recommended answer beside it. Then stop and wait for the user's answers before opening the next round.

Format a round like so:

```
❓ **Q1** - **<question title>**: <question body, possibly several paragraphs, including the choices>

➡️ <your recommended answer>

---

❓ **Q2** - **<question title>**: <question body, possibly several paragraphs, including the choices>

➡️ <your recommended answer>
```

Word each question so that a plain "yes" adopts your recommended answer. A question whose answer rests on another question still open in this round does not belong here — hold it for a later round rather than inviting a guess.

## Recompute the frontier

Each batch of answers reshapes the tree: settled decisions push the frontier outward and unblock the questions that depended on them. Recompute the frontier and open the next round. Never surface a question before its prerequisites are settled.

## Facts are yours; decisions are the user's

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment — the filesystem, tools, anything a sub-agent can look up — dispatch a sub-agent to find it; never put to the user something you could discover yourself. A running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the report; ask the rest of the frontier now rather than stalling the round. The _decisions_ are the user's alone: put each to them and wait.

## Done

The session is complete when the frontier is empty — every branch of the design tree visited, nothing left silently assumed. Do not act on the plan until the user confirms you have reached a shared understanding.

## Verification

- Every question asked sat on the frontier: its prerequisites were settled first.
- Each question is numbered, carries a recommended answer, and a "yes" accepts it.
- No question asked the user for a fact you could have looked up yourself.
- The session closed only when the frontier was empty, and you acted only after the user confirmed shared understanding.

## Pitfalls

- **Asking the user for facts** submit from the filesystem or tools is a failure — dispatch a sub-agent instead.
- **Stalling the round on a running exploration**: only the questions downstream of a pending fact wait; ask the rest now.
- **Leaking dependent questions** into the current round and inviting guesses; move anything resting on an open answer to a later round.
- **Premature completion**: declaring the frontier empty while a branch still hides an unstated assumption; walk the tree branch by branch first.
- **Acting without confirmation**: starting work before the user signs off on the shared understanding.