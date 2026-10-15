---
description: "Create a feature branch with sequential or timestamp numbering"
---

# Create Feature Branch

Create and switch to a new git feature branch for the given specification. This command handles **branch creation only** — the spec directory and files are created by the core `__SPECKIT_COMMAND_SPECIFY__` workflow.

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).


## Prerequisites

- Verify Git is available by running `git rev-parse --is-inside-work-tree 2>/dev/null`
- If Git is not available, warn the user and skip branch creation

## Branch Numbering Mode

Determine the branch numbering strategy by checking configuration in this order:

1. Check `.specify/extensions/git/git-config.yml` for `branch_numbering` value
2. Check `.specify/init-options.json` for `branch_numbering` value (backward compatibility)
3. Default to `sequential` if neither exists

## Execution

Generate a concise short name (2-4 words) for the branch:
- Analyze the feature description and extract the most meaningful keywords
- Use action-noun format when possible (e.g., "add-user-auth", "fix-payment-bug")
- Preserve technical terms and acronyms (OAuth2, API, JWT, etc.)

Run the ANEUS feature script (it creates `aux-development/spec-NNN-name`, `aux-stage/spec-NNN-name` and `spec-NNN-name` from `development`, `stage` and `production`, and checks out `aux-development/spec-NNN-name`). Use `SPEC_DIR` from the output (`specs/NNN-name`) as the spec directory:

- **Bash**: `scripts/feature-start.sh --json "<short-name>"`

If the feature's target is a registered repository (not ANEUS), after the spec is written also run
`scripts/feature-start.sh "<NNN-short-name>" --repo <name>` for each target repository.

**IMPORTANT**:
- Do NOT pass a number — the script determines the correct next number automatically
- Always include the JSON flag (`--json` for Bash, `-Json` for PowerShell) so the output can be parsed reliably
- You must only ever run this script once per feature
- The JSON output will contain `BRANCH_NAME` and `FEATURE_NUM`

## Graceful Degradation

If Git is not installed or the current directory is not a Git repository:
- Branch creation is skipped with a warning: `[specify] Warning: Git repository not detected; skipped branch creation`
- The script still outputs `BRANCH_NAME` and `FEATURE_NUM` so the caller can reference them

## Output

The script outputs JSON with:
- `BRANCH_NAME`: The working branch (e.g., `aux-development/spec-003-user-auth`)
- `SPEC_DIR`: The spec directory (e.g., `specs/003-user-auth`)
- `BRANCHES`: The three branches created
- `FEATURE_NUM`: The numeric or timestamp prefix used
