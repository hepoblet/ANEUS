# Changelog

All notable changes to the ANEUS repository are documented in this file.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project adheres to [Semantic Versioning](https://semver.org/).
Packages under `packages/` keep their own `CHANGELOG.md`.

## [Unreleased]

### Changed
- ANEUS is now only a monorepo of shared `@aneus/*` libraries. Specs and agent workflow move to Requiem, to be installed later.
- Branching: one work branch per change (`feat/`, `fix/`, `docs/`, `chore/`) into `development`, then promotion by pull request `development` → `stage` → `production`. Replaces the three branches per feature with cherry-picks.
- `release` script rewritten in Node (`scripts/release.mjs`) so it runs on Windows, macOS and Linux.
- Requires Node.js 22+.
- Principles moved from the Spec Kit constitution to `AGENTS.md`; `CLAUDE.md` imports it.

### Removed
- Spec Kit: `.specify/`, the `speckit-*` skills and the constitution.
- Multi-repository hub: `repos.json`, `workspace/`, `targets/`, `specs/` and the `repo-add`, `repo-list`, `repo-sync` and `feature-start` scripts.

## [0.1.0] - 2026-10-14

### Added
- Spec Kit setup (Claude integration) with constitution v1.0.0 for a multi-repository hub.
- `Target` and `Purpose` fields in the spec template; `Target` in the plan template.
- Target repository registry: `repos.json`, `workspace/` (git-ignored clones) and `targets/` profiles.
- Branching model: `production` (default), `stage`, `development`, plus `aux-development/spec-NNN-name`, `aux-stage/spec-NNN-name` and `spec-NNN-name` feature branches per spec.
- Scripts: `feature-start`, `repo-add`, `repo-list`, `repo-sync` and `release` (cut from `production`).
- `/speckit-specify` creates the three feature branches through `scripts/feature-start.sh`; Spec Kit scripts accept the `spec-` branch prefix.
- `packages/` workspace for shared `@aneus/*` libraries.
