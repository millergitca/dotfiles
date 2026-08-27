#!/usr/bin/env bash

set -Eeuo pipefail

VERSION="0.1.0"
APPLY=false

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'

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

OPTIONAL_COMMANDS=(
    zsh
    ghostty
    nvim
    code
    Hyprland
)

banner() {
    printf "\n"
    printf "${RED}${BOLD}MNCM LABS${RESET}\n"
    printf "${BOLD}ARCH LINUX BOOTSTRAP${RESET}\n"
    printf "${DIM}Version %s${RESET}\n" "$VERSION"
    printf "\n"
}

info() {
    printf "${BLUE}::${RESET} %s\n" "$*"
}

success() {
    printf "${GREEN}✓${RESET} %s\n" "$*"
}

warn() {
    printf "${YELLOW}!${RESET} %s\n" "$*"
}

fail() {
    printf "${RED}✗${RESET} %s\n" "$*"
}

section() {
    printf "\n"
    printf "${BOLD}%s${RESET}\n" "$1"
    printf '%*s\n' "${#1}" '' | tr ' ' '-'
}

usage() {
cat <<USAGE_EOF

MNCM Labs Arch Linux Bootstrap

Usage:

  ./scripts/bootstrap.sh
      Audit the system.

  ./scripts/bootstrap.sh --apply
      Apply currently supported installation steps.

  ./scripts/bootstrap.sh --help
      Display help.

  ./scripts/bootstrap.sh --version
      Display version.

Default audit mode does not intentionally modify the system.

USAGE_EOF
}

for arg in "$@"; do
    case "$arg" in
        --apply)
            APPLY=true
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        --version|-v)
            echo "$VERSION"
            exit 0
            ;;
        *)
            echo "Unknown argument: $arg" >&2
            usage
            exit 1
            ;;
    esac
done

banner

if [[ "$APPLY" == true ]]; then
    warn "APPLY MODE ENABLED"
    warn "Supported installation operations may modify this system."
else
    info "AUDIT MODE"
    info "No package installation will be intentionally performed."
fi

section "SYSTEM"

if [[ ! -r /etc/os-release ]]; then
    fail "Unable to read /etc/os-release."
    exit 1
fi

source /etc/os-release

info "Detected OS: ${PRETTY_NAME:-Unknown}"

if [[ "${ID:-}" != "arch" && "${ID_LIKE:-}" != *"arch"* ]]; then
    fail "MNCM Bootstrap currently targets Arch Linux."
    exit 1
fi

success "Arch Linux detected."

if ! command -v pacman >/dev/null 2>&1; then
    fail "pacman was not found."
    exit 1
fi

success "pacman available."

section "USER"

info "User: $(id -un)"
info "Home: $HOME"
info "Shell: ${SHELL:-Unknown}"

if [[ "$(id -u)" -eq 0 ]]; then
    fail "Do not run MNCM Bootstrap directly as root."
    exit 1
fi

success "Running as regular user."

section "BASE PACKAGES"

missing_base=()

for package in "${BASE_PACKAGES[@]}"; do
    if pacman -Q "$package" >/dev/null 2>&1; then
        success "$package"
    else
        warn "$package missing"
        missing_base+=("$package")
    fi
done

section "DEVELOPMENT PACKAGES"

missing_dev=()

for package in "${DEV_PACKAGES[@]}"; do
    if pacman -Q "$package" >/dev/null 2>&1; then
        success "$package"
    else
        warn "$package missing"
        missing_dev+=("$package")
    fi
done

section "DEVELOPMENT ENVIRONMENT"

for command_name in "${OPTIONAL_COMMANDS[@]}"; do
    if command -v "$command_name" >/dev/null 2>&1; then
        success "$command_name found"
    else
        warn "$command_name not currently available"
    fi
done

section "CONFIGURATION"

CONFIG_DIRS=(
    "$HOME/.config/hypr"
    "$HOME/.config/waybar"
    "$HOME/.config/ghostty"
    "$HOME/.config/nvim"
    "$HOME/.config/Code/User"
)

for directory in "${CONFIG_DIRS[@]}"; do
    if [[ -d "$directory" ]]; then
        success "$directory"
    else
        warn "$directory not found"
    fi
done

section "REPOSITORY"

REPO_ROOT="$(
    cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
    pwd
)"

info "Repository: $REPO_ROOT"

EXPECTED_COMPONENTS=(
    zsh
    ghostty
    hypr
    waybar
    nvim
)

for component in "${EXPECTED_COMPONENTS[@]}"; do
    if [[ -e "$REPO_ROOT/$component" ]]; then
        success "$component component found"
    else
        warn "$component component not found"
    fi
done

if [[ "$APPLY" == false ]]; then
    section "AUDIT COMPLETE"

    echo ""

    if (( ${#missing_base[@]} > 0 )); then
        warn "Missing base packages:"
        printf '  %s\n' "${missing_base[@]}"
    else
        success "All base packages installed."
    fi

    echo ""

    if (( ${#missing_dev[@]} > 0 )); then
        warn "Missing development packages:"
        printf '  %s\n' "${missing_dev[@]}"
    else
        success "All current development packages installed."
    fi

    echo ""
    success "Audit finished."
    info "No installation changes were made."
    echo ""
    info "Apply mode is available with:"
    echo ""
    printf "  ${BOLD}./scripts/bootstrap.sh --apply${RESET}\n"
    echo ""

    exit 0
fi

section "APPLY"

packages_to_install=(
    "${missing_base[@]}"
    "${missing_dev[@]}"
)

if (( ${#packages_to_install[@]} == 0 )); then
    success "No package installation required."
else
    warn "Packages scheduled for installation:"

    echo ""
    printf '  %s\n' "${packages_to_install[@]}"
    echo ""

    read -r -p "Continue with pacman installation? [y/N] " response

    case "$response" in
        y|Y|yes|YES)
            sudo pacman -S --needed "${packages_to_install[@]}"
            ;;
        *)
            warn "Package installation skipped."
            ;;
    esac
fi

section "POST-INSTALL CHECK"

failed=false

for package in "${BASE_PACKAGES[@]}" "${DEV_PACKAGES[@]}"; do
    if pacman -Q "$package" >/dev/null 2>&1; then
        success "$package"
    else
        warn "$package still missing"
        failed=true
    fi
done

echo ""

if [[ "$failed" == true ]]; then
    warn "Bootstrap completed with missing components."
else
    success "Current bootstrap phase completed successfully."
fi

echo ""
info "Dotfile deployment is intentionally disabled."
info "Safe backup/deployment will be added in the next phase."
echo ""
