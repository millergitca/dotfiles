#!/usr/bin/env bash

set -Eeuo pipefail

ROOT="$(
    cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
    pwd
)"

cd "$ROOT"

VERSION="$(cat VERSION)"
TAG="v$VERSION"

echo ""
echo "MNCM LABS RELEASE"
echo "$TAG"
echo ""

./scripts/release-check.sh

echo ""
echo "This script prepares a Git tag."
echo "It does not force-push or overwrite an existing tag."
echo ""

if git rev-parse "$TAG" >/dev/null 2>&1; then
    echo "Tag already exists: $TAG"
    exit 1
fi

read -r -p "Create and push $TAG? [y/N] " answer

case "$answer" in
    y|Y|yes|YES)
        git tag -a "$TAG" -m "MNCM Labs $TAG"
        git push origin "$TAG"
        echo "Release tag pushed: $TAG"
        ;;
    *)
        echo "Release cancelled."
        ;;
esac
