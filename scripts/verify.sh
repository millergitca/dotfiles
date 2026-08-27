#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(
    cd "$(dirname "${BASH_SOURCE[0]}")" &&
    pwd
)"

echo ""
echo "MNCM LABS"
echo "POST-INSTALL VERIFICATION"
echo ""

"$SCRIPT_DIR/health.sh"
