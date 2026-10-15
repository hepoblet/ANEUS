#!/usr/bin/env bash
# Lists registered target repositories and whether they are cloned locally.
set -euo pipefail
cd "$(dirname "$0")/.."
node -e '
const fs = require("fs");
const { repos } = JSON.parse(fs.readFileSync("repos.json", "utf8"));
if (!repos.length) { console.log("No target repositories registered. Use scripts/repo-add.sh"); process.exit(0); }
for (const r of repos)
  console.log(r.name.padEnd(24), (fs.existsSync(r.path) ? "cloned" : "MISSING").padEnd(8), r.base.padEnd(10), r.remote);
'
