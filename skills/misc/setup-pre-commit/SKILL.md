---
name: setup-pre-commit
description: Set up Husky pre-commit hooks with lint-staged (Prettier), type checking, and tests in the current repo. Use when user wants to add pre-commit hooks, set up Husky, configure lint-staged, or add commit-time formatting/typechecking/testing.
---

# Setup Pre-Commit Hooks

Wire quality gates into the repo's commit path so nothing ships unformatted, untyped, or untested. The hook chain runs **fast formatting on staged files first**, then the full typecheck and test suite.

## What this sets up

- **Husky** pre-commit hook
- **lint-staged** running Prettier on all staged files
- **Prettier** config (if missing)
- **typecheck** and **test** scripts in the pre-commit hook

## Steps

### 1. Detect package manager

Look for `package-lock.json` (npm), `pnpm-lock.yaml` (pnpm), `yarn.lock` (yarn), `bun.lockb` (bun) and use whichever is present. Default to npm if it's unclear. Record the choice — every later command must use it.

**Done when:** one package manager is selected and confirmed present.

### 2. Install dependencies

Install as devDependencies:

```
husky lint-staged prettier
```

**Done when:** all three appear in `devDependencies`.

### 3. Initialize Husky

```bash
npx husky init
```

This creates the `.husky/` directory and adds `prepare: "husky"` to `package.json`.

**Done when:** `.husky/` exists and the `prepare` script is `"husky"`.

### 4. Create `.husky/pre-commit`

Write this file (no shebang needed for Husky v9+):

```
npx lint-staged
npm run typecheck
npm run test
```

**Adapt:** replace `npm` with the package manager detected in step 1. If the repo has no `typecheck` or `test` script in `package.json`, omit those lines and tell the user which gates were skipped and why.

**Done when:** the file exists, is executable, and references only scripts that actually exist (plus `lint-staged`).

### 5. Create `.lintstagedrc`

```json
{
  "*": "prettier --ignore-unknown --write"
}
```

**Done when:** the file exists and targets `prettier --ignore-unknown --write`.

### 6. Create `.prettierrc` (if missing)

Create only if no Prettier config already exists. Use these defaults:

```json
{
  "useTabs": false,
  "tabWidth": 2,
  "printWidth": 80,
  "singleQuote": false,
  "trailingComma": "es5",
  "semi": true,
  "arrowParens": "always"
}
```

**Done when:** a Prettier config exists (either pre-existing or the one you created).

### 7. Verify

- [ ] `.husky/pre-commit` exists and is executable
- [ ] `.lintstagedrc` exists
- [ ] `prepare` script in `package.json` is `"husky"`
- [ ] a `prettier` config exists
- [ ] `npx lint-staged` runs successfully against a staged change

### 8. Commit

Stage all changed/created files and commit with message: `Add pre-commit hooks (husky + lint-staged + prettier)`.

This commit runs through the new hooks — the best smoke test that everything is wired. **Done when:** the commit succeeds with the hooks passing.

## Verification checklist

- [ ] Package manager consistent across every command
- [ ] `.husky/pre-commit` exists, executable, and adapted to the detected manager
- [ ] Hook omits gates the repo doesn't have, and the user was told
- [ ] `npx lint-staged` runs clean
- [ ] A real commit passes through all hooks

## Notes

- Husky v9+ doesn't need shebangs in hook files
- `prettier --ignore-unknown` skips files Prettier can't parse (images, etc.)
- Order matters: lint-staged runs first (fast, staged-only), then the full typecheck and tests

## Pitfalls

- **Match the dependency script names exactly.** If the repo's scripts are `check`/`lint`/`typecheck` differently, copy the real names into the hook — a hook calling a non-existent script fails every commit.
- **Staged-only formatting hides the rest.** lint-staged only touches staged files, so pre-existing unformatted files silently stay dirty; that's expected, not a bug in the setup.
- **Husky may need a re-init if `.husky` already exists** — overwriting it can orphan existing hooks. Merge additions rather than replacing the folder.