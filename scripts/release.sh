#!/usr/bin/env bash
# Usage: scripts/release.sh <patch|minor|major>
# Bumps the hub version, moves "Unreleased" entries in CHANGELOG.md under the new version,
# commits and tags vX.Y.Z on production. Push with: git push --follow-tags
set -euo pipefail
cd "$(dirname "$0")/.."
bump="${1:?usage: release.sh <patch|minor|major>}"
[[ "$(git branch --show-current)" == production ]] || { echo "error: releases are cut from the production branch" >&2; exit 1; }
[[ -z "$(git status --porcelain)" ]] || { echo "error: working tree is not clean" >&2; exit 1; }

version=$(node -e '
const fs = require("fs");
const p = JSON.parse(fs.readFileSync("package.json", "utf8"));
let [a, b, c] = p.version.split(".").map(Number);
const k = process.argv[1];
if (k === "major") [a, b, c] = [a + 1, 0, 0];
else if (k === "minor") [b, c] = [b + 1, 0];
else if (k === "patch") c++;
else { console.error("error: bump must be patch, minor or major"); process.exit(1); }
p.version = `${a}.${b}.${c}`;
fs.writeFileSync("package.json", JSON.stringify(p, null, 2) + "\n");
console.log(p.version);
' "$bump")

node -e '
const fs = require("fs");
const [v, d] = process.argv.slice(1);
let s = fs.readFileSync("CHANGELOG.md", "utf8");
if (!/## \[Unreleased\]\n+(?=### )/.test(s)) { console.error("error: no entries under [Unreleased]"); process.exit(1); }
s = s.replace("## [Unreleased]", `## [Unreleased]\n\n## [${v}] - ${d}`);
fs.writeFileSync("CHANGELOG.md", s);
' "$version" "$(date +%F)" || { git checkout -- package.json; exit 1; }

git add package.json CHANGELOG.md
git commit -m "chore(release): v$version"
git tag -a "v$version" -m "v$version"
echo "Released v$version. Push with: git push --follow-tags"
