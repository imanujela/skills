---
name: grill-with-docs
description: A relentless interview to sharpen a plan or design, which also creates docs (ADRs and glossary) as we go. Use in a session with a working directory, whenever an idea, plan, or design needs sharpening before implementation.
disable-model-invocation: true
---

Call the Skill tool twice, for "grilling" and "domain-modeling".

Done when both skills are loaded: the interview runs under "grilling" (facts vs decisions), and every resolved term lands in `GLOSSARY.md` and every qualifying decision in `docs/adr/` the moment it crystallises, via "domain-modeling".

## Verification

Both skills were invoked (not one); the paper trail exists — `GLOSSARY.md` updated and ADRs written inline, using the formats those skills specify.

## Pitfalls

- Loading only "grilling": the interview happens but `GLOSSARY.md` and ADRs never materialise — the docs are the difference from `/grill-me`.
- Using this with no working directory, where nothing can be saved; use `/grill-me` there.
