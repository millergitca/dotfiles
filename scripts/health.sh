#!/usr/bin/env bash

set -u

VERSION="0.5.1"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

PASS=0
WARNINGS=0
FAILURES=0
SKIPPED=0

HOST_TYPE="unknown"
ARCH_HOST=false
MACOS_HOST=false

pass() {
    PASS=$((PASS + 1))
    printf "${GREEN}✓${RESET} %s\n" "$*"
}

warn() {
    WARNINGS=$((WARNINGS + 1))
    printf "${YELLOW}!${RESET} %s\n" "$*"
}

fail() {
    FAILURES=$((FAILURES + 1))
    printf "${RED}✗${RESET} %s\n" "$*"
}

skip() {
    SKIPPED=$((SKIPPED + 1))
    printf "${CYAN}-${RESET} SKIPPED: %s\n" "$*"
}

heading() {
    printf "\n${BOLD}%s${RESET}\n" "$1"
    printf '%*s\n' "${#1}" '' | tr ' ' '-'
}

command_check() {
    local name="$1"
    local command_name="$2"

    if command -v "$command_name" >/dev/null 2>&1; then
        pass "$name"
    else
        warn "$name not found"
    fi
}

detect_host() {
    local kernel

    kernel="$(uname -s 2>/dev/null || echo unknown)"

    case "$kernel" in

        Darwin)
            HOST_TYPE="macOS"
            MACOS_HOST=true
            return
            ;;

        Linux)
            HOST_TYPE="Linux"

            if [[ -r /etc/os-release ]]; then
                source /etc/os-release

                if [[ "${ID:-}" == "arch" || "${ID_LIKE:-}" == *"arch"* ]]; then
                    HOST_TYPE="Arch Linux"
                    ARCH_HOST=true
                fi
            fi
            return
            ;;

        *)
            HOST_TYPE="$kernel"
            return
            ;;

    esac
}

printf "\n"
printf "${RED}${BOLD}MNCM LABS${RESET}\n"
printf "${BOLD}SYSTEM HEALTH CHECK${RESET}\n"
printf "Version %s\n" "$VERSION"
printf "\n"

detect_host

heading "HOST"

printf "Detected: %s\n" "$HOST_TYPE"

if [[ "$ARCH_HOST" == true ]]; then
    pass "Supported Arch Linux host detected"
elif [[ "$MACOS_HOST" == true ]]; then
    pass "macOS development host detected"
else
    warn "Unsupported development host detected"
fi

if [[ "$(id -u)" -eq 0 ]]; then
    warn "Health check is running as root"
else
    pass "Running as regular user"
fi

heading "CORE DEVELOPMENT"

command_check "Git" git
command_check "GitHub CLI" gh
command_check "Zsh" zsh
command_check "Neovim" nvim
command_check "Ghostty" ghostty
command_check "Docker" docker
command_check "ripgrep" rg
command_check "fd" fd
command_check "fzf" fzf
command_check "jq" jq
command_check "rsync" rsync

heading "GIT"

if command -v git >/dev/null 2>&1; then

    if git config user.name >/dev/null 2>&1 ||
       git config --global user.name >/dev/null 2>&1; then
        pass "Git username configured"
    else
        warn "Git username not configured"
    fi

    if git config user.email >/dev/null 2>&1 ||
       git config --global user.email >/dev/null 2>&1; then
        pass "Git email configured"
    else
        warn "Git email not configured"
    fi

else
    skip "Git configuration checks"
fi

heading "GITHUB"

if command -v gh >/dev/null 2>&1; then

    if gh auth status >/dev/null 2>&1; then
        pass "GitHub CLI authenticated"
    else
        warn "GitHub CLI not authenticated"
    fi

else
    skip "GitHub authentication check"
fi

heading "NEOVIM"

if command -v nvim >/dev/null 2>&1; then

    if nvim --headless '+quit' >/dev/null 2>&1; then
        pass "Neovim starts successfully"
    else
        warn "Neovim headless startup returned an error"
    fi

else
    skip "Neovim startup test"
fi

heading "DOCKER"

if command -v docker >/dev/null 2>&1; then

    if docker info >/dev/null 2>&1; then
        pass "Docker daemon available"
    else
        warn "Docker installed but daemon unavailable"
    fi

else
    skip "Docker daemon test"
fi

heading "ARCH-SPECIFIC CHECKS"

if [[ "$ARCH_HOST" == true ]]; then

    if command -v pacman >/dev/null 2>&1; then
        pass "pacman available"
    else
        fail "pacman unavailable on Arch host"
    fi

    command_check "Hyprland" Hyprland
    command_check "Waybar" waybar

    if [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
        pass "Wayland session detected"
    else
        warn "Wayland session not currently detected"
    fi

    if [[ "${XDG_CURRENT_DESKTOP:-}" == *"Hyprland"* ]]; then
        pass "Hyprland desktop session detected"
    else
        warn "Hyprland is not the active desktop session"
    fi

    heading "ARCH CONFIGURATION"

    for path in \
        ".config/hypr" \
        ".config/waybar" \
        ".config/ghostty" \
        ".config/nvim"
    do

        if [[ -e "$HOME/$path" ]]; then
            pass "$HOME/$path"
        else
            warn "$HOME/$path missing"
        fi

    done

else

    skip "pacman"
    skip "Hyprland"
    skip "Waybar"
    skip "Wayland session"
    skip "Hyprland desktop session"
    skip "Arch configuration validation"

fi

heading "BROKEN SYMLINKS"

if [[ -d "$HOME/.config" ]]; then

    BROKEN=""

    if find "$HOME/.config" -xtype l -print >/dev/null 2>&1; then

        BROKEN="$(
            find "$HOME/.config" \
                -xtype l \
                -print \
                2>/dev/null || true
        )"

        if [[ -z "$BROKEN" ]]; then
            pass "No broken symlinks found under ~/.config"
        else
            warn "Broken symlinks detected:"
            printf "%s\n" "$BROKEN"
        fi

    else

        if [[ "$MACOS_HOST" == true ]]; then
            skip "GNU-style broken symlink scan on macOS"
        else
            warn "Unable to perform broken symlink scan"
        fi

    fi

else
    skip "~/.config symlink scan"
fi

heading "RESULT"

printf "\n"
printf "Passed:   %s\n" "$PASS"
printf "Warnings: %s\n" "$WARNINGS"
printf "Skipped:  %s\n" "$SKIPPED"
printf "Failures: %s\n" "$FAILURES"
printf "\n"

if (( FAILURES > 0 )); then
    printf "${RED}${BOLD}STATUS: FAILED${RESET}\n"
    exit 1
fi

if [[ "$MACOS_HOST" == true ]]; then

    if (( WARNINGS > 0 )); then
        printf "${YELLOW}${BOLD}STATUS: DEVELOPMENT HOST // WARNINGS${RESET}\n"
    else
        printf "${GREEN}${BOLD}STATUS: DEVELOPMENT HOST${RESET}\n"
    fi

    exit 0
fi

if [[ "$ARCH_HOST" == true ]]; then

    if (( WARNINGS > 0 )); then
        printf "${YELLOW}${BOLD}STATUS: ARCH HOST // WARNINGS${RESET}\n"
    else
        printf "${GREEN}${BOLD}STATUS: HEALTHY${RESET}\n"
    fi

    exit 0
fi

printf "${YELLOW}${BOLD}STATUS: UNSUPPORTED DEVELOPMENT HOST${RESET}\n"
exit 0
