# packages/

One folder per shared library, published under the `@aneus` scope. Each package is an npm workspace of this repo.

Planned shape:
```
packages/<name>/
  package.json     "name": "@aneus/<name>", its own version
  src/             source; index.ts is the only public entry point
  __tests__/
  README.md        what it does, how to install, how to use
  CHANGELOG.md     one entry per change
```

Before adding a package, check it against the principles in the root `AGENTS.md`: it needs a real second consumer, and it is verified from a local tarball in a real app before publishing.

Empty for now. The shared tooling (TypeScript config, lint, tests) and a package template come first; see the roadmap in the root README.
