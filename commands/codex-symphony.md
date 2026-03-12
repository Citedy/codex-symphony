---
description: Bootstrap or start local OpenAI Symphony + Linear orchestration for the current repository
---
Read `.claude/skills/codex-symphony/SKILL.md` and follow it.

If the repository is not bootstrapped yet, run:

```bash
bash .claude/skills/codex-symphony/scripts/install.sh
```

If the repository is already bootstrapped, prefer:

```bash
./scripts/symphony/start-background.sh
```

Then report only:

- whether Symphony was started or was already running
- dashboard URL
- any missing env vars that block startup
