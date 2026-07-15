#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "==> Bash syntax"

bash -n bootstrap.sh
bash -n install.sh

while IFS= read -r -d '' file; do
  bash -n "$file"
done < <(find lib -type f -name '*.sh' -print0)

echo "✓ Bash syntax passed"

echo
echo "==> ShellCheck"

shellcheck bootstrap.sh install.sh lib/*.sh

echo "✓ ShellCheck passed"

echo
echo "==> Git whitespace"

git diff --check

echo "✓ Git whitespace passed"

echo
echo "All checks passed."
