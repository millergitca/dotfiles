#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(
    cd "$(dirname "${BASH_SOURCE[0]}")" &&
    pwd
)"

ROOT="$(
    cd "$SCRIPT_DIR/.." &&
    pwd
)"

cd "$ROOT"

echo ""
echo "MNCM LABS"
echo "RELEASE READINESS"
echo ""

FAILED=false

check() {
    local description="$1"
    shift

    if "$@" >/dev/null 2>&1; then
        echo "✓ $description"
    else
        echo "✗ $description"
        FAILED=true
    fi
}

check "bootstrap syntax" bash -n scripts/bootstrap.sh
check "installer syntax" bash -n scripts/install.sh
check "dotfile syntax" bash -n scripts/dotfiles.sh
check "health syntax" bash -n scripts/health.sh
check "verify syntax" bash -n scripts/verify.sh
check "VERSION exists" test -s VERSION
check "README exists" test -s README.md
check "installation docs" test -s docs/INSTALL.md
check "safety docs" test -s docs/SAFETY.md
check "troubleshooting docs" test -s docs/TROUBLESHOOTING.md
check "architecture docs" test -s docs/ARCHITECTURE.md

echo ""

if [[ "$FAILED" == true ]]; then
    echo "STATUS: NOT READY"
    exit 1
fi

echo "STATUS: RELEASE CHECK PASSED"
echo ""
echo "This does not mean v1.0 is production-ready."
echo "It means repository-level validation passed."
