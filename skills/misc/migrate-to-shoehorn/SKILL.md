---
name: migrate-to-shoehorn
description: Migrate test files from `as` type assertions to @total-typescript/shoehorn. Use when user mentions shoehorn, wants to replace `as` in tests, or needs partial test data.
---

# Migrate to Shoehorn

Replace `as` type assertions in **test code** with the type-safe helpers from `@total-typescript/shoehorn`. This is a migration, not a drop-in rename: each helper changes what TypeScript actually demands, so the typecheck is the final judge of whether a replacement is correct.

## Why shoehorn?

`shoehorn` lets you pass partial data in tests while keeping TypeScript happy, replacing `as` assertions with helpers that preserve autocomplete and only loosen the checks you intend to loosen.

**Test code only.** Never use shoehorn in production code — it exists precisely to relax type-safety, which is the opposite of what production code wants.

Why `as` is the wrong tool in tests:

- Best practice trains developers not to use `as`, so it reads as a code smell
- `as Type` forces you to manually spell the target type at every call site
- Intentionally-wrong data requires the ugly double assertion `as unknown as Type`

## Install

```bash
npm i @total-typescript/shoehorn
```

## Migration patterns

### Large objects with few needed properties

Before — you fake the entire shape even though only one field matters:

```ts
type Request = {
  body: { id: string };
  headers: Record<string, string>;
  cookies: Record<string, string>;
  // ...20 more properties
};

it("gets user by id", () => {
  // Only care about body.id but must fake entire Request
  getUser({
    body: { id: "123" },
    headers: {},
    cookies: {},
    // ...fake all 20 properties
  });
});
```

After — pass just what you need:

```ts
import { fromPartial } from "@total-typescript/shoehorn";

it("gets user by id", () => {
  getUser(
    fromPartial({
      body: { id: "123" },
    }),
  );
});
```

### `as Type` → `fromPartial()`

Before:

```ts
getUser({ body: { id: "123" } } as Request);
```

After:

```ts
import { fromPartial } from "@total-typescript/shoehorn";

getUser(fromPartial({ body: { id: "123" } }));
```

### `as unknown as Type` → `fromAny()`

Before:

```ts
getUser({ body: { id: 123 } } as unknown as Request); // wrong type on purpose
```

After:

```ts
import { fromAny } from "@total-typescript/shoehorn";

getUser(fromAny({ body: { id: 123 } }));
```

## When to use each

| Function        | Use case                                           |
| --------------- | -------------------------------------------------- |
| `fromPartial()` | Pass partial data that still type-checks           |
| `fromAny()`     | Pass intentionally wrong data (keeps autocomplete) |
| `fromExact()`   | Force full object (swap with fromPartial later)    |

## Workflow

### 1. Gather requirements

Ask the user:

- Which test files have `as` assertions causing problems?
- Are they dealing with large objects where only some properties matter?
- Do they need to pass intentionally wrong data for error testing?

**Done when:** the target test files are identified.

### 2. Install and migrate

- [ ] Install: `npm i @total-typescript/shoehorn` — **done when** the package appears in `package.json`
- [ ] Find test files with `as` assertions: `grep -r " as [A-Z]" --include="*.test.ts" --include="*.spec.ts"` — **done when** you have a full list of files and matches
- [ ] Replace `as Type` with `fromPartial()` — **done when** no direct `as` assertions for forced test data remain in the target tests
- [ ] Replace `as unknown as Type` with `fromAny()` — **done when** no double-as remains
- [ ] Add imports from `@total-typescript/shoehorn` — **done when** every migrated file imports the helpers it uses
- [ ] Run the typecheck — **done when** it passes with zero errors

## Verification checklist

- [ ] `grep -r " as [A-Z]" --include="*.test.ts" --include="*.spec.ts"` returns no remaining forced-data assertions in the migrated files
- [ ] Typecheck passes with zero errors
- [ ] Test suite passes after migration (re-run tests, not just typecheck)

## Pitfalls

- **A failing typecheck after `fromPartial` is a real signal, not a bug.** `fromPartial()` changes which properties are required; if the object is missing something the real code reads, migration will correctly stop compiling. The right fix is to add the property or restructure — not to paper over it with `fromAny()`.
- **`fromAny()` disables checking entirely.** Use it only for intentionally-wrong data on error paths, never as a lazy way to make a sloppy `fromPartial()` compile.
- **Don't migrate everything.** Leave `as const`, legitimate assertions, and non-test `as` uses alone. Only migrate `as` that forces test data into a type.
- **Double-as migration can change runtime behaviour.** If the faked data was silently missing required fields, the old code skipped reads at runtime; after migration those fields are genuinely required. Re-run the tests, not just the typecheck, to catch it.