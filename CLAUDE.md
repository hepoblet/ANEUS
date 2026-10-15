# ANEUS

Spec-driven hub (Spec Kit) for building features across multiple repositories, plus shared `@aneus/*` libraries. See `.specify/memory/constitution.md` and `README.md`.

- All repository content (code, specs, docs, commits) is in English.
- Specs live in `specs/NNN-name/`; code lives in the target repository (`workspace/<repo>`) or in `packages/`.
- Before planning or implementing, read the target profile `targets/<repo>.md`.
- Registered repositories: `repos.json` (`scripts/repo-add.sh`, `repo-list.sh`, `repo-sync.sh`).
- Workflow: `/speckit-specify` → `/speckit-clarify` → `/speckit-plan` → `/speckit-tasks` → `/speckit-implement`.
- Branching: `production` (default), `stage`, `development`. Each feature gets `aux-development/spec-NNN-name`, `aux-stage/spec-NNN-name` and `spec-NNN-name`, created with `scripts/feature-start.sh` (add `--repo <name>` for target repositories). Work on `aux-development/`, cherry-pick to `aux-stage/` and then `spec-NNN-name`, one PR per base.
- Never commit directly to `production`, `stage` or `development`, in ANEUS or in target repositories.
- Every hub change adds an entry under `[Unreleased]` in `CHANGELOG.md`.
- Keep `README.md` up to date when adding scripts, folders or workflow steps.

<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan
<!-- SPECKIT END -->
