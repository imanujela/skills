---
name: implement
description: "Implement a piece of work based on a spec or set of tickets. Use when the user points at a ticket or spec and asks to build it, or after /to-tickets when a single self-contained ticket is ready to be worked."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

If the user passes a ticket reference, fetch it from the issue tracker and state its title before starting. If the reference is ambiguous, ask.

Call the Skill tool with "tdd" where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, call the Skill tool with "code-review" to review the work.

Commit your work to the current branch.

## Done when

- [ ] The ticket/spec was fetched (if a reference was given) and its title stated before any code was written.
- [ ] The "tdd" skill was driven at each seam where a concrete behaviour could be specified.
- [ ] Typechecking and the focused test file ran throughout; the full suite ran once at the end and is green.
- [ ] "code-review" was called on the work and its findings addressed.
- [ ] The work is committed to the current branch, with a message that names the ticket and the behaviour delivered.

## Pitfalls

- **Skipping the title check.** Building against a misread ticket wastes the whole slice; state the fetched title up front so the user can correct it.
- **Holding the full suite until the end.** Running it once at the finish is the plan — but typechecking and the focused test file should run continuously, so a broken build is caught in the slice, not the last minute.
- **Forgetting "code-review".** The two-axis review is part of `/implement`'s contract, not an optional extra.
