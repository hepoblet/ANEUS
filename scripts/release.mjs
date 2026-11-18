#!/usr/bin/env node
// Usage: npm run release -- <patch|minor|major>
// Bumps the repo version, moves the "Unreleased" entries in CHANGELOG.md under the new version,
// commits and tags vX.Y.Z. Must run on the production branch with a clean working tree.
// Push afterwards with: git push --follow-tags
import fs from 'node:fs';
import path from 'node:path';
import { execFileSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
process.chdir(root);

function fail(message) {
  console.error(`error: ${message}`);
  process.exit(1);
}
const git = (...args) => execFileSync('git', args, { encoding: 'utf8' }).trim();

const bump = process.argv[2];
if (!['patch', 'minor', 'major'].includes(bump)) fail('usage: npm run release -- <patch|minor|major>');
if (git('branch', '--show-current') !== 'production') fail('releases are cut from the production branch');
if (git('status', '--porcelain')) fail('working tree is not clean');

const changelogFile = 'CHANGELOG.md';
const changelog = fs.readFileSync(changelogFile, 'utf8');
if (!/## \[Unreleased\]\n+(?=### )/.test(changelog)) fail('no entries under [Unreleased] in CHANGELOG.md');

const pkgFile = 'package.json';
const pkg = JSON.parse(fs.readFileSync(pkgFile, 'utf8'));
let [major, minor, patch] = pkg.version.split('.').map(Number);
if (bump === 'major') [major, minor, patch] = [major + 1, 0, 0];
else if (bump === 'minor') [minor, patch] = [minor + 1, 0];
else patch += 1;
const version = `${major}.${minor}.${patch}`;
const now = new Date();
const pad = (n) => String(n).padStart(2, '0');
const today = `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())}`; // local date

pkg.version = version;
fs.writeFileSync(pkgFile, JSON.stringify(pkg, null, 2) + '\n');
fs.writeFileSync(changelogFile, changelog.replace('## [Unreleased]', `## [Unreleased]\n\n## [${version}] - ${today}`));

git('add', pkgFile, changelogFile);
git('commit', '-m', `chore(release): v${version}`);
git('tag', '-a', `v${version}`, '-m', `v${version}`);
console.log(`Released v${version}. Push with: git push --follow-tags`);
