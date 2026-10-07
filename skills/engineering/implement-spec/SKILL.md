---
name: implement-spec
description: "Implement the result of /to-spec and /to-tickets in code, orchestrating implementer subagents across the ticket graph's frontier onto one integration branch."
disable-model-invocation: true
---

You have been provided a spec. This spec should have tickets associated with it, describing how to implement the spec.

The issue tracker should have been provided to you. If not, tell the user to run `/setup-matt-pocock-skills`.

The goal is the entire spec implemented on a single **integration branch**, with every ticket resolved the way the issue tracker closes work.

The tickets are not a list of steps. They are a **task graph** with blocking relationships between them. This means there is always a **frontier** of tickets which are ready to be grabbed.

Communication to and from subagents should be sparse. Communicate primarily through **context pointers**: to the spec, tickets, research notes, and previous commits. Don't duplicate information already available via pointers.

**Implementer subagents** should be run in the background where possible for maximum concurrency.

## Steps

1. Read the spec and tickets to understand the task graph.

2. (optional) Use an **exploration subagent** to conduct any exploration required by the tickets - relevant codebase files or external documentation. Ensure the exploration subagent can save files - it should save its markdown notes in a directory outside the repo, accessible by all future subagents. This lets **implementer subagents** focus on implementation rather than exploration.

3. Create the integration branch. If the issue tracker closes work through PRs, or the user asks for one, open a draft PR after the first merge in step 5 (a branch with no commits ahead of main can't open one), marked as closing the spec and tickets.

4. Use **implementer subagents** to implement each ticket, each in its own worktree on its own branch. Each implementer subagent:
   - confirms its worktree is based on the integration branch before starting, and resets onto it if not;
   - calls the Skill tool with `tdd` to build the ticket;
   - merges the integration branch tip into its own branch before reporting done

5. Once an **implementer subagent** completes, merge its work to the integration branch with a **merger subagent**.

6. If this changes the **frontier** of available tickets, kick off more **implementer subagents** to work on the new tickets. This allows for maximum concurrency.

7. Once all tickets are complete, call the Skill tool with `code-review` on the integration branch. Fix all issues raised by the code review in a single **implementer subagent**.

8. If a draft PR exists, mark it ready for review. Otherwise, resolve each ticket the way the issue tracker closes work, and report the integration branch.

9. Clean up all **implementer subagent** worktrees.

## Done when

- [ ] Every ticket is resolved on the integration branch, and its **blocking edges** were the only ordering constraint honoured (the frontier was worked in parallel, not serially).
- [ ] No ticket was implemented before all its blockers merged to the integration branch.
- [ ] The `code-review` skill ran over the integration branch and every raised issue was fixed in the single follow-up implementer.
- [ ] Each implementer confirmed its worktree was based on the integration branch and merged the integration tip back in before reporting done.
- [ ] All implementer worktrees are cleaned up; the integration branch (and any draft PR) is left marked ready or resolved per step 8.

## Pitfalls

- **Treating the tickets as a step list.** The task graph is there to expose parallelism; working top-to-bottom ignores the frontier and halves the concurrency this skill exists for.
- **Implementing before blockers merge.** An implementer that started against a stale integration tip produces conflicts at merge time; the worktree-reset check exists to prevent exactly this.
- **Duplicating context.** Re-sending spec details that are already reachable by pointer bloats subagent prompts and lets the copies drift; point, don't paste.
- **Running implementers sequentially.** Background-first is the rule; a stalled frontier defeats the purpose.
