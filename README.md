# folio-cli

Knowledge management over git. A bash CLI — the sole interface to the folio knowledgebase. No `.folio` files, no project binding, works from anywhere.

```bash
curl -fsSL https://raw.githubusercontent.com/jubalm/folio-cli/main/install.sh | bash
```

Requires: `git`, `gh` (GitHub CLI, authenticated). `folio dash` additionally requires `node`.

## Commands

```
folio bind <ns/repo>         One-time: clone knowledge repo, check auth
folio switch                 List amendments (* = active)
folio switch -c <topic>      Create + switch to a new amendment
folio switch <topic>         Switch to an existing amendment
folio status                 On main | amendment: <topic> — dirty/clean/PR
folio sync                   On main: pull. In amendment: rebase → commit → push → draft PR
folio sync -m "msg"          Non-interactive (agents)
folio drop <topic> --force   Abandon an amendment (local + remote)
folio config                 Show global config
folio config <key> [<val>]   Get or set a config value
folio list                   List all amendments with status and PR
folio dash [--no-open]       Launch local review/merge dashboard
```

## Quick start

```bash
# One-time setup
folio bind jubalm/folio

# Session start — orient and pull latest
folio status
folio sync

# Capture knowledge
folio switch -c my-topic
# edit leaves in ~/.config/folio/stores/amendments/my-topic/leaves/
folio sync -m "why this matters"   # submits a draft PR

# Later, abandon or switch
folio drop my-topic --force
```

## Dash

```bash
folio dash                 # start tokenized localhost dashboard + open browser
folio dash --no-open       # print URL only (headless-safe)
folio dash --port 8765     # explicit port
```

Dash is the human review/control surface: Folio health, amendment/PR inbox, PR details with changed files + diffs, squash-merge, drop, and cleanup controls. It binds to `127.0.0.1` and requires the random token printed in the URL. Editing stays out of scope; edit Markdown in amendment worktrees.

## How it works

A bash CLI wrapping `git` and `gh`, with an embedded Node server for `folio dash`. No daemon, no database. Amendments are git worktrees of a single canonical clone at `~/.config/folio/stores/.main/`. Each amendment lives in `stores/amendments/<topic>/` and syncs as its own draft PR. Rebase-always keeps knowledge history linear. The PR body IS the editorial record.

## Upgrade

Re-run the install command — it's idempotent:

```bash
curl -fsSL https://raw.githubusercontent.com/jubalm/folio-cli/main/install.sh | bash
```
