# Codex Symphony

Portable OpenAI Symphony bootstrap for any Git repository.

This package installs a local Symphony + Linear orchestration setup into the current repository without requiring a fixed absolute path. It is designed for developers who want to:

- run Symphony locally against a repo
- use Linear as the issue queue
- let Codex pick up `Todo` issues and work them in isolated workspaces
- reopen Codex later and restart everything with one command

## What It Installs

Inside the target repository:

- `WORKFLOW.symphony.md`
- `scripts/symphony/start-local.sh`
- `scripts/symphony/start-background.sh`
- `scripts/symphony/status.sh`
- `.env.symphony.example`

Inside the user environment:

- `~/.local/bin/codex-symphony`
- `~/.codex/skills/codex-symphony` symlink

## Quick Install

### Standalone Repo via OpenSkills

```bash
npx openskills install Citedy/codex-symphony
```

### Standalone Repo via GitHub

```bash
git clone https://github.com/Citedy/codex-symphony.git
cd /path/to/your-target-repo
bash /path/to/codex-symphony/scripts/install.sh
```

### From `@citedy/skills`

```bash
npx @citedy/skills install symphony
```

### Direct Local Usage

If you already have this repository somewhere on disk, run from the repository you want to automate:

```bash
bash /path/to/codex-symphony/scripts/install.sh
```

Or explicitly target a repo path:

```bash
bash /path/to/codex-symphony/scripts/install.sh /absolute/path/to/your/repo
```

## Required Environment Variables

Copy `.env.symphony.example` into your repo env setup and set:

```bash
LINEAR_API_KEY=
LINEAR_PROJECT_SLUG=
SOURCE_REPO_URL=
SYMPHONY_WORKSPACE_ROOT=
SYMPHONY_PORT=4080
```

Optional:

```bash
GH_TOKEN=
```

## Start

From inside the target repository:

```bash
codex-symphony
```

That will:

1. start Symphony in the background if it is not already running
2. print the dashboard URL
3. open Codex in the current shell

## Dashboard

Default:

```text
http://127.0.0.1:4080/
```

## Status

```bash
./scripts/symphony/status.sh
```

## Notes

- This package writes `WORKFLOW.symphony.md`, not `WORKFLOW.md`, to avoid collisions with repo-specific files.
- The workflow assumes active Linear states `Todo` and `In Progress`.
- If your team uses different state names, edit `WORKFLOW.symphony.md`.
- The package is structured so it can live either inside `Citedy/skills` or in a dedicated `Citedy/codex-symphony` repository without internal file changes.
