#!/usr/bin/env bash
# Usage: scripts/feature-start.sh <short-name | NNN-name> [--repo <name>] [--push] [--json]
#
# Creates the three feature branches, each from its own long-lived base branch:
#   aux-development/spec-NNN-name <- development
#   aux-stage/spec-NNN-name       <- stage
#   spec-NNN-name                 <- production
# and checks out aux-development/spec-NNN-name.
#
# Without --repo it runs in the ANEUS hub; with --repo it runs in workspace/<name>
# (base branch names come from that repo's "branches" entry in repos.json).
# A short name ("user-auth") gets the next feature number; "001-user-auth" or "spec-001-user-auth" is used as is.
set -euo pipefail
HUB="$(cd "$(dirname "$0")/.." && pwd)"

name="" repo="" push=false json=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) repo="${2:?--repo needs a value}"; shift 2 ;;
    --push) push=true; shift ;;
    --json) json=true; shift ;;
    -h|--help) sed -n '2,13p' "$0"; exit 0 ;;
    *) [[ -z "$name" ]] || { echo "error: unexpected argument '$1'" >&2; exit 1; }; name="$1"; shift ;;
  esac
done
[[ -n "$name" ]] || { echo "usage: feature-start.sh <short-name | NNN-name> [--repo <name>] [--push] [--json]" >&2; exit 1; }

log() { if $json; then echo "$@" >&2; else echo "$@"; fi; }

# Resolve repository and base branch names.
if [[ -n "$repo" ]]; then
  read -r dir prod stg dev < <(node -e '
const { repos } = require(process.argv[1] + "/repos.json");
const r = repos.find(x => x.name === process.argv[2]);
if (!r) { console.error(`error: repo '"'"'${process.argv[2]}'"'"' is not registered`); process.exit(1); }
const b = { production: "production", stage: "stage", development: "development", ...(r.branches || {}) };
console.log(process.argv[1] + "/" + r.path, b.production, b.stage, b.development);
' "$HUB" "$repo")
  [[ -d "$dir/.git" ]] || { echo "error: $dir is not cloned (run npm run repo:sync)" >&2; exit 1; }
else
  dir="$HUB" prod=production stg=stage dev=development
fi
cd "$dir"

# Normalize the feature name: kebab-case, numbered.
slug=$(echo "$name" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9-]+/-/g; s/^-+|-+$//g; s/^spec-//')
if [[ "$slug" =~ ^[0-9]{3,}- ]]; then
  feature="$slug"
else
  max=0
  for n in $( (ls "$HUB/specs" 2>/dev/null; git -C "$HUB" for-each-ref --format='%(refname:lstrip=-1)' 'refs/heads/' 'refs/remotes/origin/') | sed 's/^spec-//' | grep -oE '^[0-9]{3,}' ); do
    (( 10#$n > max )) && max=$((10#$n))
  done
  feature=$(printf '%03d-%s' $((max + 1)) "$slug")
fi

git fetch --quiet origin "$prod" "$stg" "$dev" 2>/dev/null || log "warning: could not fetch from origin, using local base branches"

base_ref() {
  if git rev-parse --verify --quiet "refs/remotes/origin/$1" >/dev/null; then echo "origin/$1"
  elif git rev-parse --verify --quiet "refs/heads/$1" >/dev/null; then echo "$1"
  else echo "error: base branch '$1' not found in $dir" >&2; exit 1; fi
}

pairs=("aux-development/spec-$feature:$dev" "aux-stage/spec-$feature:$stg" "spec-$feature:$prod")
for p in "${pairs[@]}"; do
  b="${p%%:*}"
  git rev-parse --verify --quiet "refs/heads/$b" >/dev/null && { echo "error: branch $b already exists" >&2; exit 1; }
  base_ref "${p#*:}" >/dev/null
done

for p in "${pairs[@]}"; do
  b="${p%%:*}" base=$(base_ref "${p#*:}")
  git branch --quiet --no-track "$b" "$base"
  git config "branch.$b.aneus-base" "${p#*:}"
  log "created $b <- $base"
  if $push; then git push --quiet -u origin "$b" && log "pushed  $b"; fi
done
git checkout --quiet "aux-development/spec-$feature"
log "switched to aux-development/spec-$feature"

if $json; then
  printf '{"BRANCH_NAME":"aux-development/spec-%s","FEATURE_NUM":"%s","SPEC_DIR":"specs/%s","BRANCHES":["aux-development/spec-%s","aux-stage/spec-%s","spec-%s"]}\n' \
    "$feature" "${feature%%-*}" "$feature" "$feature" "$feature" "$feature"
fi
