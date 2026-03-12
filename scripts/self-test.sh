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
git -C "$TEST_REPO" remote add origin https://github.com/example/example.git

bash "$SKILL_ROOT/scripts/install.sh" "$TEST_REPO" >/dev/null

test -f "$TEST_REPO/WORKFLOW.symphony.md"
test -f "$TEST_REPO/.env.symphony.example"
test -x "$TEST_REPO/scripts/symphony/common.sh"
test -x "$TEST_REPO/scripts/symphony/doctor.sh"
test -x "$TEST_REPO/scripts/symphony/init.sh"
test -x "$TEST_REPO/scripts/symphony/logs.sh"
test -x "$TEST_REPO/scripts/symphony/restart.sh"
test -x "$TEST_REPO/scripts/symphony/start-local.sh"
test -x "$TEST_REPO/scripts/symphony/start-background.sh"
test -x "$TEST_REPO/scripts/symphony/status.sh"
test -x "$TEST_REPO/scripts/symphony/stop.sh"
grep -qx '\.symphony/' "$TEST_REPO/.gitignore"
grep -qx '\.env\.symphony\.local' "$TEST_REPO/.gitignore"
test -L "$HOME/.codex/skills/codex-symphony"
test -x "$HOME/.local/bin/codex-symphony"

printf 'linear-key\ntest-project\nhttps://github.com/example/example.git\n/tmp/codex-symphony-workspaces\n4099\n\n' | \
  "$TEST_REPO/scripts/symphony/init.sh"

test -f "$TEST_REPO/.env.symphony.local"
grep -q '^LINEAR_PROJECT_SLUG=test-project$' "$TEST_REPO/.env.symphony.local"
"$TEST_REPO/scripts/symphony/doctor.sh" >/dev/null

echo "codex-symphony self-test passed"
echo "test repo: $TEST_REPO"
