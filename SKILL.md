---
name: codex-symphony
title: "OpenAI Symphony Bootstrap"
description: >
  Install and operate a portable OpenAI Symphony + Linear orchestration setup in
  any Git repository. Use when the user wants a one-command local Symphony
  runner, a reusable WORKFLOW template, background launch scripts, or a Codex
  wrapper that restarts Symphony automatically when reopening the CLI.
version: "1.0.0"
author: Citedy
tags:
  - symphony
  - codex
  - linear
  - orchestration
  - automation
  - developer-tools
---

# Codex Symphony

Use this skill when the user wants to install or operate a local OpenAI Symphony setup for a repository.

## When to Use

Use this skill when the user asks to:

- install Symphony into a repo
- restart Symphony after reopening Codex
- add a reusable `codex-symphony` command
- bootstrap Linear-driven agent orchestration
- create a portable Symphony package for another machine or repo

## Core Rule

Do not assume a fixed repository path.

Always resolve the target repo by:

1. explicit argument, if the user gave one
2. `git rev-parse --show-toplevel`, if running inside a repo
3. otherwise ask for the repo path

## Install

Run the bundled installer:

```bash
bash scripts/install.sh [optional-repo-path]
```

The installer will:

- copy `WORKFLOW.symphony.md`
- copy `scripts/symphony/*`
- copy `.env.symphony.example`
- append `.symphony/` to `.gitignore` if missing
- install `~/.local/bin/codex-symphony`
- link this skill into `~/.codex/skills/codex-symphony`

## Operate

After install, the normal commands are:

```bash
codex-symphony
./scripts/symphony/start-background.sh
./scripts/symphony/status.sh
```

## Required Env

The target repo must provide:

- `LINEAR_API_KEY`
- `LINEAR_PROJECT_SLUG`
- `SOURCE_REPO_URL`
- `SYMPHONY_WORKSPACE_ROOT`

Optional:

- `GH_TOKEN`
- `SYMPHONY_PORT`

## Expected Help Pattern

When helping the user:

1. run the installer if the repo is not bootstrapped yet
2. tell the user which env vars are still missing
3. start Symphony only after the repo is configured
4. report dashboard URL and log path only
