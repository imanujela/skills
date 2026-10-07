# Design It Twice

When the user wants to explore alternative interfaces for a chosen deepening candidate, use this parallel sub-agent pattern. Based on "Design It Twice" (Ousterhout): your first idea is unlikely to be the best.

Uses the vocabulary in [SKILL.md](SKILL.md): **module**, **interface**, **seam**, **adapter**, **leverage**.

## Process

### 1. Frame the problem space

Before spawning sub-agents, write a user-facing explanation of the problem space for the chosen candidate:

- The constraints any new interface would need to satisfy
- The dependencies it would rely on, and which category they fall into (see [DEEPENING.md](DEEPENING.md))
- A rough illustrative code sketch to ground the constraints, not a proposal, just a way to make the constraints concrete

Show this to the user, then immediately proceed to Step 2. The user reads and thinks while the sub-agents work in parallel.

Done when the framing names the constraints, each dependency's category, and includes the grounding sketch — and it was shown to the user *before* the sub-agents spawned.

### 2. Spawn sub-agents

Spawn 3+ sub-agents in parallel. Each must produce a **radically different** interface for the deepened module.

Prompt each sub-agent with a separate technical brief (file paths, coupling details, dependency category from [DEEPENING.md](DEEPENING.md), what sits behind the seam). The brief is independent of the user-facing problem-space explanation in Step 1. Give each agent a different design constraint:

- Agent 1: "Minimize the interface: aim for 1–3 entry points max. Maximise leverage per entry point."
- Agent 2: "Maximise flexibility: support many use cases and extension."
- Agent 3: "Optimise for the most common caller: make the default case trivial."
- Agent 4 (if applicable): "Design around ports & adapters for cross-seam dependencies."

Include both [SKILL.md](SKILL.md) vocabulary and GLOSSARY.md vocabulary in the brief so each sub-agent names things consistently with the architecture language and the project's domain language.

Each sub-agent outputs:

1. Interface (types, methods, params, plus invariants, ordering, error modes)
2. Usage example showing how callers use it
3. What the implementation hides behind the seam
4. Dependency strategy and adapters (see [DEEPENING.md](DEEPENING.md))
5. Trade-offs: where leverage is high, where it's thin

Done when all sub-agent calls went out in one message, each brief carries its distinct constraint, and every returned design has all five output parts — a design missing trade-offs is not a design, it's a pitch.

### 3. Present and compare

Present designs sequentially so the user can absorb each one, then compare them in prose. Contrast by **depth** (leverage at the interface), **locality** (where change concentrates), and **seam placement**.

After comparing, give your own recommendation: which design you think is strongest and why. If elements from different designs would combine well, propose a hybrid. Be opinionated: the user wants a strong read, not a menu.

Done when the comparison covers all three axes for every design, and the response ends with a named pick and the reason — or an explicit hybrid with which pieces came from where.

## Verification

The design-it-twice run was correct when:

- 3+ sub-agents ran **in parallel** (single message, not sequential calls), each with its own constraint brief.
- No two returned designs are structurally similar; if they are, the constraint split failed and at least one was redone.
- The user saw the problem-space framing before the results arrived.
- The comparison names depth, locality, and seam placement per design, and ends with a recommendation — not a neutral menu.

## Pitfalls

- **Slightly-different designs.** Three variants that all assume the same shape ("maybe with more methods") aren't design-it-twice; each brief's constraint must actually bite.
- **Skipping the framing.** Spawning agents before writing the problem space leaves them inventing constraints, and the user can't follow the comparison.
- **The fence-sitting ending.** Presenting four designs and asking "which do you like?" — the skill asks for your opinionated read.
- **Vocabulary drift in briefs.** Omitting the SKILL.md/GLOSSARY.md terms from the briefs produces designs named in a private dialect that don't compare cleanly.
- **Sequential spawning.** Calling the sub-agents one after another wastes the parallelism and lets earlier designs anchor later ones.
