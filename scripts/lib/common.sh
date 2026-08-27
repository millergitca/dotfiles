#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

mncm_info() {
    printf "${BLUE}::${RESET} %s\n" "$*"
}

mncm_ok() {
    printf "${GREEN}✓${RESET} %s\n" "$*"
}

mncm_warn() {
    printf "${YELLOW}!${RESET} %s\n" "$*"
}

mncm_error() {
    printf "${RED}✗${RESET} %s\n" "$*" >&2
}

mncm_die() {
    mncm_error "$*"
    exit 1
}

mncm_heading() {
    printf "\n${BOLD}%s${RESET}\n" "$1"
    printf '%*s\n' "${#1}" '' | tr ' ' '-'
}

mncm_banner() {
    printf "\n"
    printf "${RED}${BOLD}███╗   ███╗███╗   ██╗ ██████╗███╗   ███╗${RESET}\n"
    printf "${RED}${BOLD}████╗ ████║████╗  ██║██╔════╝████╗ ████║${RESET}\n"
    printf "${RED}${BOLD}██╔████╔██║██╔██╗ ██║██║     ██╔████╔██║${RESET}\n"
    printf "${RED}${BOLD}██║╚██╔╝██║██║╚██╗██║██║     ██║╚██╔╝██║${RESET}\n"
    printf "${RED}${BOLD}██║ ╚═╝ ██║██║ ╚████║╚██████╗██║ ╚═╝ ██║${RESET}\n"
    printf "${RED}${BOLD}╚═╝     ╚═╝╚═╝  ╚═══╝ ╚═════╝╚═╝     ╚═╝${RESET}\n"
    printf "\n"
    printf "${BOLD}MNCM LABS // ARCH LINUX BOOTSTRAP${RESET}\n"
    printf "${DIM}Build. Break. Learn. Repeat.${RESET}\n"
    printf "\n"
}
