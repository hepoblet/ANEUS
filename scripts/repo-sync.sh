#!/usr/bin/env bash
# Clones any registered target repository that is missing (e.g. on a new machine).
set -euo pipefail
cd "$(dirname "$0")/.."
node -e '
const fs = require("fs"), cp = require("child_process");
const { repos } = JSON.parse(fs.readFileSync("repos.json", "utf8"));
for (const r of repos) {
  if (fs.existsSync(r.path)) { console.log(`ok       ${r.name}`); continue; }
  console.log(`cloning  ${r.name}`);
  cp.execFileSync("git", ["clone", "--branch", r.base, r.remote, r.path], { stdio: "inherit" });
}
'
