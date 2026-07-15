#!/usr/bin/env bash
set -Eeuo pipefail

VERSION="${1:-}"
TITLE="${2:-}"

fail() {
  printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2
  exit 1
}

success() {
  printf '\033[1;32m[SUCCESS]\033[0m %s\n' "$*"
}

info() {
  printf '\n\033[1;34m[INFO]\033[0m %s\n' "$*"
}

command -v git >/dev/null 2>&1 ||
  fail "Git is not installed."

command -v gh >/dev/null 2>&1 ||
  fail "GitHub CLI is not installed."

[[ -n "$VERSION" ]] ||
  fail "Usage: make release VERSION=x.y.z [TITLE=\"Release Title\"]"

[[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] ||
  fail "VERSION must use semantic versioning, for example: 1.2.0"

TAG="v$VERSION"

if [[ -z "$TITLE" ]]; then
  TITLE="$TAG"
fi

info "Checking repository"

git rev-parse --is-inside-work-tree >/dev/null 2>&1 ||
  fail "This command must be run inside a Git repository."

[[ -z "$(git status --porcelain)" ]] ||
  fail "Working tree is not clean. Commit or stash your changes first."

git remote get-url origin >/dev/null 2>&1 ||
  fail "The origin remote is not configured."

gh auth status >/dev/null 2>&1 ||
  fail "GitHub CLI is not authenticated. Run: gh auth login"

if git rev-parse "$TAG" >/dev/null 2>&1; then
  fail "Tag $TAG already exists locally."
fi

if git ls-remote --exit-code --tags origin "refs/tags/$TAG" >/dev/null 2>&1; then
  fail "Tag $TAG already exists on origin."
fi

if gh release view "$TAG" >/dev/null 2>&1; then
  fail "GitHub Release $TAG already exists."
fi

success "Repository checks passed"

info "Running project validation"
make check
success "Project validation passed"

info "Pushing current branch"
git push

info "Creating annotated tag"
git tag -a "$TAG" -m "$TITLE"
success "Created $TAG"

info "Pushing tag"
git push origin "$TAG"

info "Creating GitHub Release"
gh release create "$TAG" \
  --title "$TITLE" \
  --generate-notes \
  --verify-tag

success "Release $TAG published"
