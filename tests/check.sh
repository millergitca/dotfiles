#!/usr/bin/env bash

set -Eeuo pipefail

ROOT="$(
    cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
    pwd
)"

cd "$ROOT"

echo ""
echo "MNCM LABS"
echo "REPOSITORY VALIDATION"
echo ""

fail() {
    echo "✗ $*"
    exit 1
}

pass() {
    echo "✓ $*"
}

echo "==> Required files"

REQUIRED_FILES=(
    README.md
    VERSION
    CHANGELOG.md
    scripts/bootstrap.sh
    scripts/install.sh
    scripts/dotfiles.sh
    scripts/health.sh
    scripts/verify.sh
    scripts/release-check.sh
    scripts/release.sh
    scripts/lib/common.sh
    docs/INSTALL.md
    docs/INSTALLER.md
    docs/SAFETY.md
    docs/TROUBLESHOOTING.md
    docs/ARCHITECTURE.md
    docs/DEVELOPMENT-HOSTS.md
    packages/core.txt
    packages/developer.txt
    packages/shell.txt
    packages/editor.txt
    packages/terminal.txt
    packages/desktop.txt
)

for file in "${REQUIRED_FILES[@]}"; do
    [[ -s "$file" ]] || fail "Missing or empty: $file"
    pass "$file"
done

echo ""
echo "==> Executable scripts"

EXECUTABLES=(
    scripts/bootstrap.sh
    scripts/install.sh
    scripts/dotfiles.sh
    scripts/health.sh
    scripts/verify.sh
    scripts/release-check.sh
    scripts/release.sh
)

for file in "${EXECUTABLES[@]}"; do
    [[ -x "$file" ]] || fail "Not executable: $file"
    pass "$file"
done

echo ""
echo "==> Bash syntax"

while IFS= read -r -d '' file; do
    echo "Checking $file"
    bash -n "$file"
done < <(
    find scripts \
        -type f \
        -name '*.sh' \
        -print0
)

pass "Bash syntax"

echo ""
echo "==> Package definitions"

for file in packages/*.txt; do

    [[ -s "$file" ]] ||
        fail "Empty package file: $file"

    if grep -E '^[[:space:]]+$' "$file" >/dev/null 2>&1; then
        fail "Whitespace-only line found in $file"
    fi

    pass "$file"
done

echo ""
echo "==> Version"

VERSION_VALUE="$(tr -d '[:space:]' < VERSION)"

if [[ ! "$VERSION_VALUE" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?$ ]]; then
    fail "VERSION is not semantic version format: $VERSION_VALUE"
fi

pass "Version $VERSION_VALUE"

echo ""
echo "==> ShellCheck"

if command -v shellcheck >/dev/null 2>&1; then

    mapfile -d '' SHELL_FILES < <(
        find scripts \
            -type f \
            -name '*.sh' \
            -print0
    )

    if (( ${#SHELL_FILES[@]} > 0 )); then
        shellcheck \
            --severity=error \
            --external-sources \
            "${SHELL_FILES[@]}"
    fi

    pass "ShellCheck"
else
    echo "! ShellCheck unavailable — skipped"
fi

echo ""
echo "==> Git whitespace"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git diff --check
    pass "Git whitespace"
else
    echo "! Git repository metadata unavailable — whitespace check skipped"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " ALL REPOSITORY CHECKS PASSED"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
