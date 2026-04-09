# Bun Isolated Linker Breaks ESLint Formatter Resolution

## The Bug

Bun's `linker = "isolated"` prevents ESLint from resolving `eslint-formatter-compact` when it's a **transitive dependency** (installed via another package, not a direct dep).

npm handles this correctly by hoisting the transitive dep to the top-level `node_modules/`.

## Setup

- `eslint@9.29.0` — direct devDependency
- `shared-config` — local package at `packages/shared-config/` that depends on `eslint-formatter-compact@8.40.0`
- `eslint-formatter-compact` is **not** a direct dependency — it's only reachable as a transitive dep through `shared-config`
- `bunfig.toml` has `linker = "isolated"`

This simulates a real-world setup where an internal shared config package (e.g., `@company/eslint-config`) depends on `eslint-formatter-compact`, and CI runs `eslint --format compact` for GitHub Actions problem matcher annotations.

## Reproduction

```shell
docker compose up --build
```

### Expected Output

| Service | Exit Code | Result |
|---|---|---|
| `lint-bun` | 2 | **FAIL** — `eslint-formatter-compact` not found |
| `lint-npm` | 0 | **PASS** — npm hoists the formatter to top-level |
| `generate-bun` | 0 | **PASS** — orval works with isolated linker |
| `generate-npm` | 0 | **PASS** — orval works with npm |

## The Catch-22

Without `linker = "isolated"`, orval fails due to a separate ajv peer dependency hoisting bug (see `main` branch). With `linker = "isolated"`, orval works but ESLint breaks. You can't have both working with bun.

## Error Output (bun)

```
$ bunx eslint --format compact src/
The compact formatter is no longer part of core ESLint. Install it manually with `npm install -D eslint-formatter-compact`
```

## Root Cause

ESLint resolves `--format compact` by looking for the npm package `eslint-formatter-compact` via standard `require()` resolution. With npm's hoisted `node_modules/`, the transitive dep is at the top level and `require('eslint-formatter-compact')` succeeds. With bun's isolated linker, the package is only inside `node_modules/shared-config/node_modules/eslint-formatter-compact/` and not reachable from ESLint's resolution context.

## Environment

- bun v1.3.11
- Node.js v22
- ESLint v9.29.0
- eslint-formatter-compact v8.40.0
