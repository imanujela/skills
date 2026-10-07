---
name: domain-modeling
description: Build and sharpen a project's domain model. Use when discussing codebase terminology, resolving an overloaded or vague term, writing or editing a GLOSSARY.md, or recording or editing an ADR.
---

# Domain Modeling

Actively build and sharpen the project's domain model as you design. This is the *active* discipline: challenging terms, inventing edge-case scenarios, and writing the glossary and decisions down the moment they crystallise. (Merely *reading* `GLOSSARY.md` for vocabulary is not this skill: that's a one-line habit any skill can do. This skill is for when you're changing the model, not just consuming it.)

## File structure

Most repos have a single context:

```
/
├── GLOSSARY.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

If a `GLOSSARY-MAP.md` exists at the root, the repo has multiple contexts. The map points to where each one lives:

```
/
├── GLOSSARY-MAP.md
├── docs/
│   └── adr/                          ← system-wide decisions
├── src/
│   ├── ordering/
│   │   ├── GLOSSARY.md
│   │   └── docs/adr/                 ← context-specific decisions
│   └── billing/
│       ├── GLOSSARY.md
│       └── docs/adr/
```

Create files lazily: only when you have something to write. If no `GLOSSARY.md` exists, create one when the first term is resolved. If no `docs/adr/` exists, create it when the first ADR is needed.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in `GLOSSARY.md`, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y. Which is it?"

Done when the conflict was surfaced in the same turn it appeared, quoting both the glossary definition and the user's usage — not noted for later.

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account': do you mean the Customer or the User? Those are different things."

Done when the vague term was replaced by a named canonical term (or split into explicitly named terms) and the user picked one.

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

Done when at least one concrete scenario with an edge case was posed per disputed relationship, and the scenario got an actual answer (not "we'll figure that out").

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code cancels entire Orders, but you just said partial cancellation is possible. Which is right?"

Done when the claim was checked against actual code before being accepted, and any contradiction was put to the user as an either/or question.

### Update GLOSSARY.md inline

When a term is resolved, update `GLOSSARY.md` right there. Don't batch these up: capture them as they happen. Use the format in [GLOSSARY-FORMAT.md](./GLOSSARY-FORMAT.md).

`GLOSSARY.md` should be totally devoid of implementation details. Do not treat `GLOSSARY.md` as a spec, a scratch pad, or a repository for implementation decisions. It is a glossary and nothing else.

Done when every resolved term this session appears in `GLOSSARY.md` with a canonical name, a one-or-two-sentence definition, and its `_Avoid_` list — each written within the turn it was resolved.

### Offer ADRs sparingly

Only offer to create an ADR when all three are true:

1. **Hard to reverse**: the cost of changing your mind later is meaningful
2. **Surprising without context**: a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off**: there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the ADR. Use the format in [ADR-FORMAT.md](./ADR-FORMAT.md).

Done when each ADR offer cites how the decision meets all three tests (or was skipped because one failed).

## Verification

The session ran correctly when:

- Every term conflict, fuzziness, and code contradiction raised this session got an explicit resolution in conversation.
- All resolved terms are in `GLOSSARY.md` (correct context's file, per `GLOSSARY-MAP.md` if present), in the [GLOSSARY-FORMAT.md](./GLOSSARY-FORMAT.md) shape, with zero implementation details in it.
- Any ADR written passes all three tests, follows [ADR-FORMAT.md](./ADR-FORMAT.md), and uses the next sequential number in `docs/adr/`.
- Each glossary edit landed in the same turn its term was resolved.

## Pitfalls

- **Glossary as spec.** Slipping implementation details, schemas, or TODOs into `GLOSSARY.md`. If it isn't a definition, it doesn't go in.
- **Batching writes.** Collecting resolved terms "for later" and losing them when the session compacts. Write each term the turn it's decided.
- **ADR inflation.** Recording reversible, unsurprising, or no-trade-off decisions until the log is noise nobody reads. All three tests or no ADR.
- **Accepting the user's framing.** Letting an overloaded word ("account") pass unchallenged; the ambiguity compounds into the code, so also check stated behaviour against what the code actually does.
- **Wrong context.** In a multi-context repo, writing a term into the root glossary when it belongs to `src/<context>/GLOSSARY.md`.
