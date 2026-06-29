# folio-cli

Knowledge management over git. A bash CLI that collapses 11 git/gh commands into one verb.

```bash
curl -fsSL https://raw.githubusercontent.com/jubalm/folio-cli/main/install.sh | bash
```

Requires: `git`, `gh` (GitHub CLI, authenticated).

## Usage

```bash
folio init              # initialize a store for this project
folio sync              # pull main + publish local edits via PR
folio sync -m "msg"     # non-interactive (agents)
folio list              # list all stores
folio status            # current project/store status
folio config            # show global config
folio config <key>      # get a config value
folio config <key> <v>  # set a config value
```

### Init

```bash
cd ~/Projects/my-app
folio init                         # store name = directory basename
folio init --name custom-name      # explicit store name
```

Creates `~/.config/folio/stores/<name>/` (a full clone of the knowledge repo).
Writes a `.folio` pointer file in the project (gitignored globally).

### Sync

Edits happen in the store at `~/.config/folio/stores/<name>/leaves/`. `folio sync`:

1. Pulls latest from main
2. Surfaces any open PRs
3. If there are local edits, commits + pushes + opens a PR

```bash
folio sync -m "decisions: fork-contingency qualifier"
```

### Status

```bash
$ folio status
Project:  ~/Projects/my-app
Store:    ~/.config/folio/stores/my-app
Status:   clean
```

### List

```bash
$ folio list
  STORE                     STATUS   BRANCH
  augur-reboot-site         clean    main
  hello-folio               clean    main
```

## How it works

A 332-line bash script wrapping `git` and `gh`. No daemon, no database, no session state. Stores are plain git clones of the knowledge repo. Edits are committed, pushed to a branch, and opened as a PR. The PR body IS the editorial record.

## Upgrade

Re-run the install command — it's idempotent:

```bash
curl -fsSL https://raw.githubusercontent.com/jubalm/folio-cli/main/install.sh | bash
```
