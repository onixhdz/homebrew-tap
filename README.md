# homebrew-tap

Shared Homebrew tap for realxen command-line tools.

## Purpose

This repository hosts custom Homebrew formulae under `Formula/`.

Example install flow:

```bash
brew tap realxen/tap
brew install cartograph
```

## Expected layout

```text
Formula/
  cartograph.rb
```

## Release automation

Tool repositories can publish GitHub releases, then send a `repository_dispatch`
event here so a workflow updates the matching formula with the new version and
checksums.
