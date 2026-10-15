# ANEUS

Spec-driven development hub ([Spec Kit](https://github.com/github/spec-kit)) for building features across multiple repositories, plus a monorepo of shared `@aneus/*` libraries for React Native.

Specs live here. Code lives in each feature's **target** repository, or in `packages/` when it is a shared library.

## Requirements

| Tool | Why | Install |
| --- | --- | --- |
| Git | Version control | `brew install git` |
| Node.js 18+ | Hub scripts | `brew install node` |
| GitHub CLI | PRs, repo settings | `brew install gh` then `gh auth login` |
| uv | Installs the Spec Kit CLI | `brew install uv` |
| Spec Kit CLI (`specify`) | Upgrading / checking Spec Kit | `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git` |
| Claude Code | Runs the `/speckit-*` commands | [claude.com/claude-code](https://claude.com/claude-code) |

Check the setup with `specify check`.

## Getting Started

```sh
# 1. Clone the hub and its long-lived branches
git clone git@github.com:hepoblet/ANEUS.git
cd ANEUS
git branch --track stage origin/stage
git branch --track development origin/development

# 2. Clone every registered target repository into workspace/
npm run repo:sync
npm run repo:list

# 3. Open Claude Code in the hub
claude
```

### Register a target repository

```sh
npm run repo:add -- <name> <git-remote> [clone-branch]
# e.g. npm run repo:add -- my-app git@github.com:org/my-app.git production
```

Then:

1. Fill in the generated `targets/<name>.md` (stack, commands, conventions, constraints).
2. If the repository uses other names for its long-lived branches, edit its `branches` entry in `repos.json`.
3. Add it to the [Target Repositories](#target-repositories) table below.
4. Commit `repos.json`, `targets/<name>.md` and `README.md`.

## Project Structure

```
ANEUS/
├── specs/NNN-name/     spec, plan and tasks for each feature (Target = destination repo)
├── targets/<repo>.md   target repository profile: stack, commands, conventions
├── repos.json          target repository registry
├── workspace/<repo>/   local clones of target repositories (git-ignored)
├── packages/           shared @aneus/* publishable libraries
├── scripts/            feature-start, repo-add, repo-list, repo-sync, release
├── .specify/           Spec Kit: constitution, templates, scripts
├── .claude/skills/     Spec Kit commands for Claude Code
└── CHANGELOG.md        hub changelog
```

## Spec Kit

Spec Kit drives every feature: spec → plan → tasks → code. The rules every feature must follow are in the constitution: [.specify/memory/constitution.md](./.specify/memory/constitution.md).

### Commands (run inside Claude Code)

| Command | When | What it does |
| --- | --- | --- |
| `/speckit-constitution` | Rarely | Amend the project principles (bump its version, update templates) |
| `/speckit-specify <description>` | Start of a feature | Creates the 3 feature branches and `specs/NNN-name/spec.md` (what and why, no tech) |
| `/speckit-clarify` | After specify | Asks up to 5 questions and writes the answers into the spec |
| `/speckit-checklist` | Optional | Generates a quality checklist for the spec (UX, security, API…) |
| `/speckit-plan` | Spec approved | Technical plan against `targets/<repo>.md`: `plan.md`, `research.md`, `data-model.md`, contracts |
| `/speckit-tasks` | Plan approved | Ordered, test-first `tasks.md`, grouped by repository for multi-repo features |
| `/speckit-analyze` | Before implementing | Cross-checks spec, plan and tasks for gaps and contradictions |
| `/speckit-implement` | Tasks approved | Executes `tasks.md` in the target repository |
| `/speckit-taskstoissues` | Optional | Turns `tasks.md` into GitHub issues |
| `/speckit-git-commit` | Any time | Commits pending Spec Kit changes |

### Feature Workflow

```text
/speckit-specify  →  /speckit-clarify  →  /speckit-plan  →  /speckit-tasks  →  /speckit-analyze  →  /speckit-implement
```

1. Make sure the target repository is registered (`npm run repo:list`).
2. `/speckit-specify <feature description>` — creates the feature branches in the hub and `specs/NNN-name/spec.md`. Set **Target** and **Purpose** in the spec.
3. `/speckit-clarify` until there are no open questions. Review and approve the spec.
4. `/speckit-plan` — reads `targets/<repo>.md` and plans against that repository.
5. `/speckit-tasks`, then `/speckit-analyze`.
6. Create the feature branches in each target repository:
   ```sh
   npm run feature:start -- NNN-name --repo <repo>
   ```
7. `/speckit-implement` on `aux-development/spec-NNN-name` inside `workspace/<repo>`, test first.
8. Promote to stage and production as described in [Branching](#branching).
9. If the feature is reusable and has a second consumer, extract it to `packages/`.

Spec Kit's `before_specify` / `after_*` hooks are configured in `.specify/extensions.yml`.

## Branching

| Branch | Purpose | Changes through |
| --- | --- | --- |
| `production` | Default branch, released code, release tags | PR from `spec-NNN-name` |
| `stage` | Pre-release / QA | PR from `aux-stage/spec-NNN-name` |
| `development` | Integration | PR from `aux-development/spec-NNN-name` |

Each feature gets three branches, each created from its own base:

```
development ── aux-development/spec-001-example ──PR──▶ development
stage       ── aux-stage/spec-001-example       ──PR──▶ stage
production  ── spec-001-example                 ──PR──▶ production
```

```sh
npm run feature:start -- example                       # hub: next number, e.g. spec-001-example
npm run feature:start -- 001-example --repo my-app     # same branches in workspace/my-app
npm run feature:start -- 001-example --repo my-app --push
```

Work on `aux-development/spec-NNN-name`. When it is ready for the next environment, cherry-pick its commits:

```sh
git checkout aux-stage/spec-001-example
git cherry-pick development..aux-development/spec-001-example

git checkout spec-001-example
git cherry-pick stage..aux-stage/spec-001-example
```

Long-lived branches are never merged into each other and never receive direct commits.

## Scripts

| Command | Description |
| --- | --- |
| `npm run feature:start -- <name> [--repo <repo>] [--push]` | Create the 3 feature branches from their bases |
| `npm run repo:add -- <name> <remote> [branch]` | Clone and register a target repository and create its profile |
| `npm run repo:list` | List registered repositories and their local status |
| `npm run repo:sync` | Clone missing registered repositories |
| `npm run release -- <patch\|minor\|major>` | On `production`: bump the version, update `CHANGELOG.md`, commit and tag |

## Versioning and Changelog

- The hub follows [semver](https://semver.org/): version in `package.json`, git tag `vX.Y.Z`.
- Every hub change adds an entry under `## [Unreleased]` in [CHANGELOG.md](./CHANGELOG.md) (`Added`, `Changed`, `Fixed`, `Removed`).
- To release: merge into `production`, run `npm run release -- minor` there, then `git push --follow-tags`.
- Each package in `packages/` keeps its own version and `CHANGELOG.md`.

## Target Repositories

| Name | Clone branch | Description |
| --- | --- | --- |
| _none yet_ | | |

## Packages

| Package | Description |
| --- | --- |
| _none yet_ | |

## Upgrading Spec Kit

ANEUS customizes three Spec Kit files. After `specify init --here --force` (or any upgrade), re-apply:

1. `.claude/skills/speckit-git-feature/SKILL.md` and `.specify/extensions/git/commands/speckit.git.feature.md` — the **Execution** section calls `scripts/feature-start.sh`.
2. `.specify/scripts/bash/common.sh` and `.specify/extensions/git/scripts/bash/git-common.sh` — `spec_kit_effective_branch_name` strips the `spec-` prefix.
3. `.specify/templates/spec-template.md` / `plan-template.md` — **Target** and **Purpose** fields.

Keep `.specify/memory/constitution.md` (do not overwrite it).

## License

[MIT](./LICENSE)
