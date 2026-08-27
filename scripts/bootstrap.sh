#!/usr/bin/env bash
set -Eeuo pipefail

VERSION="0.1.0"
APPLY=false

BASE_PACKAGES=(
  base-devel
  git
  github-cli
  openssh
  curl
  wget
  rsync
  zip
  unzip
  tree
  jq
  ripgrep
  fd
  fzf
)

DEV_PACKAGES=(
  docker
)

usage() {
  echo "MNCM Labs Arch Linux Bootstrap"
  echo ""
  echo "Usage:"
  echo "  ./scripts/bootstrap.sh"
  echo "  ./scripts/bootstrap.sh --apply"
  echo "  ./scripts/bootstrap.sh --version"
}

for arg in "$@"; do
  case "$arg" in
    --apply)
      APPLY=true
      ;;
    --version|-v)
      echo "$VERSION"
      exit 0
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg"
      exit 1
      ;;
  esac
done

echo ""
echo "MNCM LABS"
echo "ARCH LINUX BOOTSTRAP"
echo "Version $VERSION"
echo ""

if [[ ! -r /etc/os-release ]]; then
  echo "ERROR: Cannot detect operating system."
  exit 1
fi

source /etc/os-release

if [[ "${ID:-}" != "arch" && "${ID_LIKE:-}" != *"arch"* ]]; then
  echo "ERROR: This bootstrap currently targets Arch Linux."
  exit 1
fi

if [[ "$(id -u)" -eq 0 ]]; then
  echo "ERROR: Do not run this directly as root."
  exit 1
fi

if ! command -v pacman >/dev/null 2>&1; then
  echo "ERROR: pacman not found."
  exit 1
fi

echo "Arch Linux detected."
echo ""

missing=()

for package in "${BASE_PACKAGES[@]}" "${DEV_PACKAGES[@]}"; do
  if pacman -Q "$package" >/dev/null 2>&1; then
    echo "[OK] $package"
  else
    echo "[MISSING] $package"
    missing+=("$package")
  fi
done

if [[ "$APPLY" == false ]]; then
  echo ""
  echo "Audit complete."
  echo "No changes were made."
  echo ""
  exit 0
fi

if (( ${#missing[@]} == 0 )); then
  echo ""
  echo "Nothing needs installing."
  exit 0
fi

echo ""
echo "Packages to install:"
printf '  %s\n' "${missing[@]}"
echo ""

read -r -p "Continue? [y/N] " answer

case "$answer" in
  y|Y|yes|YES)
    sudo pacman -S --needed "${missing[@]}"
    ;;
  *)
    echo "Installation cancelled."
    ;;
esac
