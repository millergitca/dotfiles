#!/usr/bin/env bash

set -Eeuo pipefail

ROOT="$(
    cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
    pwd
)"

cd "$ROOT"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " MNCM LABS // ARCH LINUX CI"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

fail() {
    echo "✗ $*"
    exit 1
}

pass() {
    echo "✓ $*"
}

echo "==> Operating system"

[[ -r /etc/os-release ]] ||
    fail "/etc/os-release missing"

source /etc/os-release

echo "Detected: ${PRETTY_NAME:-unknown}"

[[ "${ID:-}" == "arch" ]] ||
    fail "CI environment is not Arch Linux"

pass "Arch Linux detected"

echo ""
echo "==> pacman"

command -v pacman >/dev/null 2>&1 ||
    fail "pacman not found"

pass "pacman available"

echo ""
echo "==> Bash syntax"

while IFS= read -r -d '' file; do
    echo "Checking $file"
    bash -n "$file"
done < <(
    find scripts tests \
        -type f \
        -name '*.sh' \
        -print0
)

pass "Bash syntax"

echo ""
echo "==> Installer CLI"

./scripts/install.sh --help >/dev/null
pass "Installer --help"

./scripts/install.sh --version
pass "Installer --version"

echo ""
echo "==> Dotfile CLI"

./scripts/dotfiles.sh --help >/dev/null
pass "Dotfiles --help"

./scripts/dotfiles.sh --version
pass "Dotfiles --version"

echo ""
echo "==> Arch health check"

set +e
./scripts/health.sh
HEALTH_STATUS=$?
set -e

if [[ "$HEALTH_STATUS" -gt 1 ]]; then
    fail "Health check crashed unexpectedly"
fi

pass "Health checker executed on Arch"

echo ""
echo "==> Minimal profile planning"

./scripts/install.sh \
    --profile minimal \
    --no-dotfiles

pass "Minimal profile plan"

echo ""
echo "==> Developer profile planning"

./scripts/install.sh \
    --profile developer \
    --no-dotfiles

pass "Developer profile plan"

echo ""
echo "==> Complete profile planning"

./scripts/install.sh \
    --profile complete \
    --no-dotfiles

pass "Complete profile plan"

echo ""
echo "==> Plan safety"

BEFORE="$(
    pacman -Q 2>/dev/null |
    sort |
    sha256sum |
    awk '{print $1}'
)"

./scripts/install.sh \
    --profile minimal \
    --no-dotfiles >/dev/null

AFTER="$(
    pacman -Q 2>/dev/null |
    sort |
    sha256sum |
    awk '{print $1}'
)"

[[ "$BEFORE" == "$AFTER" ]] ||
    fail "Plan mode changed installed package state"

pass "Plan mode did not install packages"

echo ""
echo "==> Release check"

./scripts/release-check.sh

pass "Release readiness"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " ARCH LINUX CI PASSED"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
