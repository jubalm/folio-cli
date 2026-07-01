# folio-cli

Knowledge management over git. A bash CLI — the sole interface to the folio knowledgebase. No `.folio` files, no project binding, works from anywhere.

```bash
curl -fsSL https://raw.githubusercontent.com/jubalm/folio-cli/main/install.sh | bash
```

Requires: `git`, `gh` (GitHub CLI, authenticated).

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
folio web                    Open Folio Web or GitHub PR list for bound repo
folio web --no-open          Print URL only
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

## Web

`folio web` opens the review/control surface for the bound repo. During the transition before Folio Web is deployed, it falls back to opening the GitHub PR list.

```bash
folio web                    # open in browser
folio web --no-open          # print URL only
```

Once Folio Web is deployed, configure its URL:

```bash
folio config web https://folio.example.com
```

## How it works

A bash CLI wrapping `git` and `gh`. The `web` command is a thin opener — no embedded server, no daemon. Amendments are git worktrees of a single canonical clone at `~/.config/folio/stores/.main/`. Each amendment lives in `stores/amendments/<topic>/` and syncs as its own draft PR. Rebase-always keeps knowledge history linear. The PR body is the editorial record.

## Upgrade

Re-run the install command — it's idempotent:

```bash
curl -fsSL https://raw.githubusercontent.com/jubalm/folio-cli/main/install.sh | bash
```
