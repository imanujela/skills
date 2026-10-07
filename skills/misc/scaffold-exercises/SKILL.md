---
name: scaffold-exercises
description: Create exercise directory structures with sections, problems, solutions, and explainers that pass linting. Use when user wants to scaffold exercises, create exercise stubs, or set up a new course section.
---

# Scaffold Exercises

Create exercise directory structures that pass `pnpm ai-hero-cli internal lint`, then commit with `git commit`. The linter is the source of truth: a scaffold is only "done" when lint and the typecheck-equivalent rules are satisfied.

## Directory naming

- **Sections**: `XX-section-name/` inside `exercises/` (e.g., `01-retrieval-skill-building`)
- **Exercises**: `XX.YY-exercise-name/` inside a section (e.g., `01.03-retrieval-with-bm25`)
- Section number = `XX`, exercise number = `XX.YY`
- Names are dash-case (lowercase, hyphens)

## Exercise variants

Each exercise needs at least one of these subfolders:

- `problem/` — student workspace with TODOs
- `solution/` — reference implementation
- `explainer/` — conceptual material, no TODOs

When stubbing, default to `explainer/` unless the plan specifies otherwise.

## Required files

Each subfolder (`problem/`, `solution/`, `explainer/`) needs a `readme.md` that:

- Is **not empty** — must have real content, even a single title line works
- Has no broken links

When stubbing, create a minimal readme with a title and a description:

```md
# Exercise Title

Description here
```

If the subfolder has code, it also needs a `main.ts` (>1 line). For stubs, a readme-only exercise is fine.

## Workflow

1. **Parse the plan** — extract section names, exercise names, and variant types. **Done when:** every section and exercise in the plan maps to a numbered, dash-case path with no numbering gaps or collisions.
2. **Create directories** — `mkdir -p` for each path. **Done when:** all directories exist on disk.
3. **Create stub readmes** — one `readme.md` per variant folder with a title. **Done when:** every variant folder has a non-empty `readme.md`.
4. **Run lint** — `pnpm ai-hero-cli internal lint`. **Done when:** lint exits 0.
5. **Fix any errors** — iterate until lint passes. **Done when:** lint passes and the new tree is committed.

## Lint rules summary

The linter (`pnpm ai-hero-cli internal lint`) checks:

- Each exercise has subfolders (`problem/`, `solution/`, `explainer/`)
- At least one of `problem/`, `explainer/`, or `explainer.1/` exists
- `readme.md` exists and is non-empty in the primary subfolder
- No `.gitkeep` files
- No `speaker-notes.md` files
- No broken links in readmes
- No `pnpm run exercise` commands in readmes
- `main.ts` required per subfolder unless it's readme-only

## Moving/renaming exercises

When renumbering or moving exercises:

1. Use `git mv` (not `mv`) to rename directories — preserves git history
2. Update the numeric prefix to maintain order
3. Re-run lint after moves

**Done when:** the move is staged via `git mv`, prefixes stay in order, and lint still passes.

Example:

```bash
git mv exercises/01-retrieval/01.03-embeddings exercises/01-retrieval/01.04-embeddings
```

## Example: stubbing from a plan

Given a plan like:

```
Section 05: Memory Skill Building
- 05.01 Introduction to Memory
- 05.02 Short-term Memory (explainer + problem + solution)
- 05.03 Long-term Memory
```

Create:

```bash
mkdir -p exercises/05-memory-skill-building/05.01-introduction-to-memory/explainer
mkdir -p exercises/05-memory-skill-building/05.02-short-term-memory/{explainer,problem,solution}
mkdir -p exercises/05-memory-skill-building/05.03-long-term-memory/explainer
```

Then create readme stubs:

```
exercises/05-memory-skill-building/05.01-introduction-to-memory/explainer/readme.md -> "# Introduction to Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/explainer/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/problem/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/solution/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.03-long-term-memory/explainer/readme.md -> "# Long-term Memory"
```

## Verification checklist

- [ ] Every planned section and exercise exists with the right numeric prefix and dash-case name
- [ ] Every variant folder has a non-empty `readme.md` with no broken links
- [ ] No `.gitkeep` or `speaker-notes.md` files anywhere in the new tree
- [ ] `pnpm ai-hero-cli internal lint` passes
- [ ] New files are committed

## Pitfalls

- **Check numbering before creating.** Two exercises accidentally numbered `01.03` will both pass `mkdir` yet fail review. Read the plan's numbering first — headings are cheap, renames are annoying.
- **A "non-empty" readme is still too small.** Existing files satisfy "exists" but an empty one fails lint; always write at least a title line.
- **Plain `mv` on a committed directory loses history.** Always `git mv` for anything already committed.
- **Don't create stray `main.ts` stubs** for readme-only exercises. The linter requires `main.ts` only when code exists, but a leftover stub can trip other rules.