# ANEUS

A monorepo of shared `@aneus/*` libraries for React Native.

Code that more than one app needs lives here once, versioned and tested, and apps install it as a package instead of copying it.

## Status

Early. The repository is being prepared; there are no packages yet.

- npm workspaces are configured (`packages/*`).
- Shared tooling (TypeScript config, lint, tests, CI) is not set up yet.
- Development will be driven with [Requiem](https://github.com/hepoblet/requiem), an agent orchestrator. It is not installed yet; this repository is being shaped so it can be.

Until v0.1.0 this repository was a spec hub built on Spec Kit for coordinating features across several repositories. That role was removed: specs and agent workflow move to Requiem, and ANEUS keeps only shared code. See the changelog.

## Structure

```
packages/<name>/   one shared library per folder, published as @aneus/<name>
scripts/           repo automation (release)
AGENTS.md          principles and rules for changing this repo
CHANGELOG.md       changes to the repo itself; each package keeps its own
```

## Principles

The full list is in [AGENTS.md](./AGENTS.md). The ones that shape the repo:

- A package exists only when there is a real second consumer.
- Test first.
- Each package is independent: own version, own changelog, one public entry point.
- A package is verified from a local tarball in a real app before it is published.

## Requirements

Node.js 22+ and git.

```sh
git clone https://github.com/hepoblet/ANEUS.git
cd ANEUS
npm install
```

## Branches

| Branch | Purpose | Changes through |
| --- | --- | --- |
| `development` | Integration | PR from a work branch (`feat/`, `fix/`, `docs/`, `chore/`) |
| `stage` | Validation | PR from `development` |
| `production` | Released; what consumers install | PR from `stage` |

Work starts on a branch from `development`. Changes move up one level at a time, and promotions use a merge commit so the three branches share history. Nobody pushes to the three branches directly.

## Versioning and changelog

- The repo follows [semver](https://semver.org/): version in `package.json`, git tag `vX.Y.Z`.
- Every change to the repo itself adds an entry under `## [Unreleased]` in [CHANGELOG.md](./CHANGELOG.md).
- To release: merge into `production`, then on that branch run
  ```sh
  npm run release -- <patch|minor|major>
  git push --follow-tags
  ```
- Each package keeps its own version and `CHANGELOG.md`.

## Roadmap

Small steps, in order.

| # | Step | Result |
| --- | --- | --- |
| 1 | Remove the spec hub, restate the repo as a monorepo | this change |
| 2 | Shared tooling: base TypeScript config, lint, test runner, one command for each at the root | every package is checked the same way |
| 3 | CI that runs those checks on every pull request | the rules apply to everyone |
| 4 | Package template and the first real package | proof the setup works end to end |
| 5 | Publishing flow: build, local tarball check, publish | a package can be consumed by an app |
| 6 | Install Requiem | features developed with the agent pipeline |

For step 6, Requiem needs a stack that describes a library monorepo; today it ships stacks for apps only.

## Packages

| Package | Description |
| --- | --- |
| _none yet_ | |

## License

[MIT](./LICENSE)
