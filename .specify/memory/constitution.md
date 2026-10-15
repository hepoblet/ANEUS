# ANEUS Constitution

ANEUS is the hub where features for multiple repositories (React Native apps and others)
are specified, planned and coordinated, and where the shared `@aneus/*` libraries live.
Specs live here; code lives in each feature's target repository.

## Core Principles

### I. Spec First (NON-NEGOTIABLE)
No feature code is written without an approved spec in `specs/`.
If behavior changes, the spec changes first, then the code.

### II. Every Feature Declares Its Target
Each spec declares a `Target`: one or more repositories registered in `repos.json`
(or `ANEUS/packages/<name>` for a shared library). Plans and tasks are written against
the target profile `targets/<repo>.md`; its commands, conventions and constraints take
precedence over generic preferences.

### III. Test First (NON-NEGOTIABLE)
TDD wherever testable: write the test, see it fail, implement, refactor. Behavior that
depends on the platform or device (native code, launchers, push) is verified against the
spec's acceptance criteria in the target repository, manually or with QA.

### IV. Minimal Changes in Target Repositories
A feature touches only what its spec requires, on its own feature branches in the target
repository (see Branching), merged through PRs. The target's
style, package manager and CI are respected. No opportunistic refactors.

### V. Simplicity
Implement only what the current spec asks for. Any extra complexity is justified in
writing in the plan (Complexity Tracking).

### VI. Shared Libraries Under `@aneus`
Code needed by more than one repository is extracted into `packages/` as a publishable
package (`@aneus` scope, independent semver, changelog entry per change). Extraction
happens only when there is a real second consumer or the spec requires it. Every package
is tested and verified from a local tarball before publishing.

### VII. Versioned Hub
ANEUS itself follows semver (`package.json` version + git tag `vX.Y.Z`). Every change
to the hub (constitution, templates, scripts, structure) adds an entry to `CHANGELOG.md`.

## Development Workflow and Branching

- All repository content (code, specs, docs, commits) is written in English.
- Long-lived branches: `production` (default, released code), `stage` (pre-release/QA) and
  `development` (integration). They only change through PRs.
- Every feature gets three branches, each created from its own base by `scripts/feature-start.sh`:
  `aux-development/spec-NNN-name` ← `development`, `aux-stage/spec-NNN-name` ← `stage`,
  `spec-NNN-name` ← `production`. Work happens on `aux-development/`; the same commits are then
  cherry-picked onto `aux-stage/` and `spec-NNN-name`, and
  each branch is merged through a PR into its own base. Long-lived branches are never merged
  into each other.
- The same model applies to target repositories (base names configurable in `repos.json`).
- One feature = `specs/NNN-name/` in ANEUS + its three branches in each target repository.
- Cycle: constitution → specify → clarify → plan → tasks → implement (Spec Kit).
- Conventional Commits in ANEUS and in target repositories (unless the target says otherwise).

## Governance

This constitution supersedes any other practice in ANEUS. Amendments require a PR that
explains the reason and updates affected templates. Versioning follows semver: MAJOR
removes or redefines a principle, MINOR adds or expands one, PATCH clarifies.

**Version**: 1.0.0 | **Ratified**: 2026-10-14 | **Last Amended**: 2026-10-14
