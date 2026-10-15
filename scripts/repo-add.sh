#!/usr/bin/env bash
# Usage: scripts/repo-add.sh <name> <git-remote> [base-branch]
# base-branch is the branch to clone (default: production).
# Edit "branches" in repos.json if the repo uses other names for production/stage/development.
# Registers a target repository: clones it into workspace/<name>, adds it to repos.json
# and creates targets/<name>.md from the template.
set -euo pipefail
cd "$(dirname "$0")/.."

name="${1:?usage: repo-add.sh <name> <git-remote> [base-branch]}"
remote="${2:?usage: repo-add.sh <name> <git-remote> [base-branch]}"
base="${3:-production}"

[[ "$name" =~ ^[a-z0-9][a-z0-9._-]*$ ]] || { echo "error: name must be lowercase kebab-case" >&2; exit 1; }
node -e 'const j=require("./repos.json");process.exit(j.repos.some(r=>r.name===process.argv[1])?1:0)' "$name" \
  || { echo "error: '$name' is already registered" >&2; exit 1; }
[[ -e "workspace/$name" ]] && { echo "error: workspace/$name already exists" >&2; exit 1; }

git clone --branch "$base" "$remote" "workspace/$name"

node -e '
const fs = require("fs");
const [name, remote, base] = process.argv.slice(1);
const j = JSON.parse(fs.readFileSync("repos.json", "utf8"));
j.repos.push({ name, remote, base, path: `workspace/${name}`, target: `targets/${name}.md`,
  branches: { production: "production", stage: "stage", development: "development" } });
fs.writeFileSync("repos.json", JSON.stringify(j, null, 2) + "\n");
' "$name" "$remote" "$base"

if [[ ! -e "targets/$name.md" ]]; then
  node -e '
const fs = require("fs");
const [name, remote, base] = process.argv.slice(1);
const t = fs.readFileSync("targets/_template.md", "utf8")
  .replace("<name>", name).replace("<remote>", remote).replace("<base>", base);
fs.writeFileSync(`targets/${name}.md`, t);
' "$name" "$remote" "$base"
fi

echo "Registered '$name' -> workspace/$name. Next: fill in targets/$name.md"
