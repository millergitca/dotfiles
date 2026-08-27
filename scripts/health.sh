#!/usr/bin/env bash

set -u

VERSION="0.5.0"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

PASS=0
WARNINGS=0
FAILURES=0

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

printf "\n"
printf "${RED}${BOLD}MNCM LABS${RESET}\n"
printf "${BOLD}SYSTEM HEALTH CHECK${RESET}\n"
printf "Version %s\n" "$VERSION"
printf "\n"

heading "OPERATING SYSTEM"

if [[ -r /etc/os-release ]]; then
    source /etc/os-release

    printf "Detected: %s\n" "${PRETTY_NAME:-Unknown}"

    if [[ "${ID:-}" == "arch" || "${ID_LIKE:-}" == *"arch"* ]]; then
        pass "Arch Linux detected"
    else
        fail "This environment is not Arch Linux"
    fi
else
    fail "/etc/os-release unavailable"
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

heading "DESKTOP"

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

heading "CONFIGURATION"

CONFIGS="
.config/hypr
.config/waybar
.config/ghostty
.config/nvim
"

printf "%s" "$CONFIGS" |
while IFS= read -r path; do

    [[ -n "$path" ]] || continue

    if [[ -e "$HOME/$path" ]]; then
        pass "$HOME/$path"
    else
        warn "$HOME/$path missing"
    fi

done

heading "BROKEN SYMLINKS"

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

heading "GIT"

if command -v git >/dev/null 2>&1; then

    if git config --global user.name >/dev/null 2>&1; then
        pass "Git username configured"
    else
        warn "Git username not configured"
    fi

    if git config --global user.email >/dev/null 2>&1; then
        pass "Git email configured"
    else
        warn "Git email not configured"
    fi

fi

heading "GITHUB"

if command -v gh >/dev/null 2>&1; then

    if gh auth status >/dev/null 2>&1; then
        pass "GitHub CLI authenticated"
    else
        warn "GitHub CLI not authenticated"
    fi

fi

heading "DOCKER"

if command -v docker >/dev/null 2>&1; then

    if docker info >/dev/null 2>&1; then
        pass "Docker daemon available"
    else
        warn "Docker installed but daemon unavailable"
    fi

fi

heading "NEOVIM"

if command -v nvim >/dev/null 2>&1; then

    if nvim --headless '+quit' >/dev/null 2>&1; then
        pass "Neovim starts successfully"
    else
        warn "Neovim headless startup returned an error"
    fi

fi

heading "RESULT"

printf "\n"
printf "Passed:   %s\n" "$PASS"
printf "Warnings: %s\n" "$WARNINGS"
printf "Failures: %s\n" "$FAILURES"
printf "\n"

if (( FAILURES > 0 )); then
    printf "${RED}${BOLD}STATUS: FAILED${RESET}\n"
    exit 1
fi

if (( WARNINGS > 0 )); then
    printf "${YELLOW}${BOLD}STATUS: WARNINGS${RESET}\n"
    exit 0
fi

printf "${GREEN}${BOLD}STATUS: HEALTHY${RESET}\n"
