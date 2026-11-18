# ANEUS

Monorepo of shared `@aneus/*` libraries for React Native. Rules for anyone, human or agent, changing this repository.

## Principles
1. **A package needs a real second consumer.** Code moves into `packages/` when more than one app needs it, or when its spec requires it. Not before.
2. **Test first.** Write the test, see it fail, implement, refactor. Behavior that depends on a device or native platform is verified against its acceptance criteria manually or with QA.
3. **Simplicity.** Implement only what was asked. Extra complexity is justified in writing before it is built.
4. **Minimal changes.** A change touches only what it requires. No opportunistic refactors.
5. **Packages are independent.** Each has its own version (semver), its own `CHANGELOG.md` and its own tests. A package never imports another package's internals, only its public entry point.
6. **Verify before publishing.** A package is tested and installed from a local tarball in a real app before it is published.
7. **The repo is versioned.** Changes to the repo itself (structure, scripts, tooling) add an entry under `[Unreleased]` in the root `CHANGELOG.md`.

## Conventions
- All repository content (code, docs, commits, branch names) is in English.
- Conventional Commits.
- Keep `README.md` up to date when adding packages, scripts or workflow steps.

## Branches
`development` (integration) → `stage` (validation) → `production` (released, default for consumers).
- Work on a branch from `development`: `feat/`, `fix/`, `docs/`, `chore/`. It returns through a pull request into `development`.
- Changes move up one level at a time, through a pull request: `development` → `stage` → `production`. Promotions use a merge commit.
- Never commit or push directly to `production`, `stage` or `development`. No force pushes.
- Releases are cut on `production` with `npm run release`.
