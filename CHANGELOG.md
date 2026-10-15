# Changelog

All notable changes to the ANEUS hub are documented in this file.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project adheres to [Semantic Versioning](https://semver.org/).
Packages under `packages/` keep their own `CHANGELOG.md`.

## [Unreleased]

## [0.1.0] - 2026-10-14

### Added
- Spec Kit setup (Claude integration) with constitution v1.0.0 for a multi-repository hub.
- `Target` and `Purpose` fields in the spec template; `Target` in the plan template.
- Target repository registry: `repos.json`, `workspace/` (git-ignored clones) and `targets/` profiles.
- Branching model: `production` (default), `stage`, `development`, plus `aux-development/spec-NNN-name`, `aux-stage/spec-NNN-name` and `spec-NNN-name` feature branches per spec.
- Scripts: `feature-start`, `repo-add`, `repo-list`, `repo-sync` and `release` (cut from `production`).
- `/speckit-specify` creates the three feature branches through `scripts/feature-start.sh`; Spec Kit scripts accept the `spec-` branch prefix.
- `packages/` workspace for shared `@aneus/*` libraries.
