---
name: grill-me
description: A relentless interview to sharpen a plan or design.
disable-model-invocation: true
---

The user wants their plan or design stress-tested, hardened, or poked at. Do not interview them yourself: delegate to the grilling skill, which owns the design-tree and frontier protocol.

**When invoked**, call the Skill tool with `"grilling"`, passing the plan or design the user wants tested. Then step back and let the grilling protocol drive the interview; you are only the trigger and the interface, not a second interviewer.

## Verification

- The Skill tool was called with `"grilling"` before you asked the user anything yourself.
- The plan or design under test was passed through to the call.

## Pitfalls

- **Interviewing inline**: skipping the Skill call and improvising questions yourself forgoes the design-tree and frontier protocol under the same name, producing an unstructured grilling that misses branches.