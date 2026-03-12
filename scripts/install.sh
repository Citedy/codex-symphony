#!/usr/bin/env bash
set -euo pipefail

SKILL_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_ROOT="${1:-}"

if [[ -z "$TARGET_ROOT" ]]; then
  TARGET_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
fi

if [[ ! -d "$TARGET_ROOT" ]]; then
  echo "Target repository does not exist: $TARGET_ROOT" >&2
  exit 1
fi

mkdir -p "$TARGET_ROOT/scripts/symphony"
mkdir -p "$HOME/.codex/skills"
mkdir -p "$HOME/.local/bin"

cp "$SKILL_ROOT/assets/start-local.sh.template" "$TARGET_ROOT/scripts/symphony/start-local.sh"
cp "$SKILL_ROOT/assets/start-background.sh.template" "$TARGET_ROOT/scripts/symphony/start-background.sh"
cp "$SKILL_ROOT/assets/status.sh.template" "$TARGET_ROOT/scripts/symphony/status.sh"
cp "$SKILL_ROOT/assets/WORKFLOW.symphony.md.template" "$TARGET_ROOT/WORKFLOW.symphony.md"
cp "$SKILL_ROOT/assets/env.symphony.example" "$TARGET_ROOT/.env.symphony.example"

chmod +x \
  "$TARGET_ROOT/scripts/symphony/start-local.sh" \
  "$TARGET_ROOT/scripts/symphony/start-background.sh" \
  "$TARGET_ROOT/scripts/symphony/status.sh"

if [[ -f "$TARGET_ROOT/.gitignore" ]]; then
  if ! grep -qx '\.symphony/' "$TARGET_ROOT/.gitignore" >/dev/null 2>&1; then
    printf '\n.symphony/\n' >> "$TARGET_ROOT/.gitignore"
  fi
else
  printf '.symphony/\n' > "$TARGET_ROOT/.gitignore"
fi

ln -sfn "$SKILL_ROOT" "$HOME/.codex/skills/codex-symphony"

cat > "$HOME/.local/bin/codex-symphony" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${CODEX_SYMPHONY_REPO:-}" ]]; then
  REPO_ROOT="$CODEX_SYMPHONY_REPO"
else
  REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
fi

if [[ -z "$REPO_ROOT" || ! -x "$REPO_ROOT/scripts/symphony/start-background.sh" ]]; then
  echo "Run codex-symphony from inside a repo that contains scripts/symphony/start-background.sh" >&2
  echo "Or export CODEX_SYMPHONY_REPO=/absolute/path/to/that/repo" >&2
  exit 1
fi

"$REPO_ROOT/scripts/symphony/start-background.sh"
exec codex "$@"
EOF

chmod +x "$HOME/.local/bin/codex-symphony"

echo "Installed Codex Symphony into: $TARGET_ROOT"
echo
echo "Created:"
echo "- $TARGET_ROOT/WORKFLOW.symphony.md"
echo "- $TARGET_ROOT/scripts/symphony/start-local.sh"
echo "- $TARGET_ROOT/scripts/symphony/start-background.sh"
echo "- $TARGET_ROOT/scripts/symphony/status.sh"
echo "- $TARGET_ROOT/.env.symphony.example"
echo
echo "Installed user tooling:"
echo "- $HOME/.local/bin/codex-symphony"
echo "- $HOME/.codex/skills/codex-symphony -> $SKILL_ROOT"
echo
echo "Next:"
echo "1. Copy variables from .env.symphony.example into your repo env"
echo "2. Set LINEAR_PROJECT_SLUG to the Linear project Symphony should watch"
echo "3. Run: cd $TARGET_ROOT && codex-symphony"
