#!/usr/bin/env bash
set -euo pipefail

SKILL_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_REPO="$(mktemp -d /tmp/codex-symphony-self-test-XXXXXX)"

cleanup() {
  if [[ -n "${TEST_REPO:-}" && -d "${TEST_REPO:-}" ]]; then
    rm -rf "$TEST_REPO"
  fi
}

trap cleanup EXIT

git init -q "$TEST_REPO"

bash "$SKILL_ROOT/scripts/install.sh" "$TEST_REPO" >/dev/null

test -f "$TEST_REPO/WORKFLOW.symphony.md"
test -f "$TEST_REPO/.env.symphony.example"
test -x "$TEST_REPO/scripts/symphony/start-local.sh"
test -x "$TEST_REPO/scripts/symphony/start-background.sh"
test -x "$TEST_REPO/scripts/symphony/status.sh"
grep -qx '\.symphony/' "$TEST_REPO/.gitignore"
test -L "$HOME/.codex/skills/codex-symphony"
test -x "$HOME/.local/bin/codex-symphony"

echo "codex-symphony self-test passed"
echo "test repo: $TEST_REPO"
