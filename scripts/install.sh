#!/usr/bin/env bash

set -Eeo pipefail

VERSION="0.4.1"

SCRIPT_DIR="$(
    cd "$(dirname "${BASH_SOURCE[0]}")" &&
    pwd
)"

REPO_ROOT="$(
    cd "$SCRIPT_DIR/.." &&
    pwd
)"

source "$SCRIPT_DIR/lib/common.sh"

PROFILE=""
APPLY=false
WITH_DOTFILES=true
PLAN_ANYWHERE=false
ARCH_HOST=false
MACOS_HOST=false

PACKAGE_GROUPS=()
COMPONENTS=()



usage() {
    cat <<EOF

MNCM Labs Arch Linux Installer v$VERSION

Usage:

  ./scripts/install.sh
      Interactive planning mode.

  ./scripts/install.sh --profile complete
      Plan the complete MNCM environment.

  ./scripts/install.sh --profile developer
      Plan the developer environment.

  ./scripts/install.sh --profile minimal
      Plan the minimal environment.

  ./scripts/install.sh --profile custom
      Select package groups interactively.

  ./scripts/install.sh --apply
      Enable package installation after confirmation.

  ./scripts/install.sh --no-dotfiles
      Do not include dotfile deployment.

  ./scripts/install.sh --plan-anywhere
      Allow plan generation from a non-Arch development host.

      This NEVER enables package installation.

  ./scripts/install.sh --version
      Show installer version.

IMPORTANT:

Planning is the default.

No packages are installed unless --apply is supplied.

EOF
}

array_contains() {
    local needle="$1"
    shift

    local item

    for item in "$@"; do
        if [[ "$item" == "$needle" ]]; then
            return 0
        fi
    done

    return 1
}

add_group() {
    local group="$1"

    if ! array_contains "$group" "${PACKAGE_GROUPS[@]}"; then
        PACKAGE_GROUPS+=("$group")
    fi
}

add_component() {
    local component="$1"

    if ! array_contains "$component" "${COMPONENTS[@]}"; then
        COMPONENTS+=("$component")
    fi
}

validate_system() {
    mncm_heading "SYSTEM"

    [[ "$(id -u)" -ne 0 ]] ||
        mncm_die "Do not run the installer directly as root."

    mncm_ok "Running as regular user"

    local kernel
    kernel="$(uname -s 2>/dev/null || echo unknown)"

    case "$kernel" in

        Darwin)
            MACOS_HOST=true
            mncm_info "Detected: macOS development host"

            if [[ "$APPLY" == true ]]; then
                mncm_die "Apply Mode is blocked on macOS. MNCM installation currently targets Arch Linux only."
            fi

            if [[ "$PLAN_ANYWHERE" != true ]]; then
                mncm_die "This is a macOS development host. Use --plan-anywhere to preview an Arch installation plan."
            fi

            mncm_ok "Development-host planning enabled"
            ;;

        Linux)

            [[ -r /etc/os-release ]] ||
                mncm_die "Unable to detect Linux distribution."

            source /etc/os-release

            mncm_info "Detected: ${PRETTY_NAME:-Unknown}"

            if [[ "${ID:-}" == "arch" || "${ID_LIKE:-}" == *"arch"* ]]; then
                ARCH_HOST=true
                mncm_ok "Arch Linux detected"
            else

                if [[ "$APPLY" == true ]]; then
                    mncm_die "Apply Mode is supported on Arch Linux only."
                fi

                if [[ "$PLAN_ANYWHERE" != true ]]; then
                    mncm_die "Unsupported Linux development host. Use --plan-anywhere for planning only."
                fi

                mncm_ok "Development-host planning enabled"
            fi
            ;;

        *)
            if [[ "$APPLY" == true ]]; then
                mncm_die "Apply Mode is supported on Arch Linux only."
            fi

            if [[ "$PLAN_ANYWHERE" != true ]]; then
                mncm_die "Unsupported host. Use --plan-anywhere for planning only."
            fi

            mncm_warn "Planning from unsupported development host: $kernel"
            ;;

    esac

    if [[ "$ARCH_HOST" == true ]]; then

        command -v pacman >/dev/null 2>&1 ||
            mncm_die "pacman not found."

        mncm_ok "pacman available"

        command -v sudo >/dev/null 2>&1 ||
            mncm_die "sudo not found."

        mncm_ok "sudo available"

        command -v rsync >/dev/null 2>&1 ||
            mncm_warn "rsync is not currently installed; core profile includes it."

        if command -v ping >/dev/null 2>&1; then

            if ping -c 1 -W 2 archlinux.org >/dev/null 2>&1; then
                mncm_ok "Network appears available"
            else
                mncm_warn "Network check did not succeed"
            fi

        else
            mncm_warn "ping unavailable; network check skipped"
        fi

    else
        mncm_info "Arch-only system checks skipped on development host"
    fi
}

show_menu() {
    printf "\n"
    printf "${BOLD}SELECT INSTALLATION PROFILE${RESET}\n"
    printf "\n"
    printf "  ${RED}[1]${RESET} MNCM COMPLETE\n"
    printf "      Full MNCM development environment\n"
    printf "\n"
    printf "  ${RED}[2]${RESET} DEVELOPER\n"
    printf "      Development environment without full desktop setup\n"
    printf "\n"
    printf "  ${RED}[3]${RESET} MINIMAL\n"
    printf "      Shell, editor and essential CLI tools\n"
    printf "\n"
    printf "  ${RED}[4]${RESET} CUSTOM\n"
    printf "      Choose package groups individually\n"
    printf "\n"

    read -r -p "Select profile [1-4]: " choice

    case "$choice" in
        1)
            PROFILE="complete"
            ;;
        2)
            PROFILE="developer"
            ;;
        3)
            PROFILE="minimal"
            ;;
        4)
            PROFILE="custom"
            ;;
        *)
            mncm_die "Invalid profile selection."
            ;;
    esac
}

custom_menu() {
    mncm_heading "CUSTOM INSTALL"

    printf "\n"
    printf "Answer y or n for each group.\n"
    printf "\n"

    read -r -p "Core CLI tools? [Y/n] " answer
    case "${answer:-Y}" in
        y|Y|yes|YES)
            add_group core
            ;;
    esac

    read -r -p "Developer languages + Docker? [Y/n] " answer
    case "${answer:-Y}" in
        y|Y|yes|YES)
            add_group developer
            ;;
    esac

    read -r -p "Zsh? [Y/n] " answer
    case "${answer:-Y}" in
        y|Y|yes|YES)
            add_group shell
            add_component zsh
            ;;
    esac

    read -r -p "Neovim? [Y/n] " answer
    case "${answer:-Y}" in
        y|Y|yes|YES)
            add_group editor
            add_component nvim
            ;;
    esac

    read -r -p "Ghostty? [Y/n] " answer
    case "${answer:-Y}" in
        y|Y|yes|YES)
            add_group terminal
            add_component ghostty
            ;;
    esac

    read -r -p "Hyprland desktop? [y/N] " answer
    case "${answer:-N}" in
        y|Y|yes|YES)
            add_group desktop
            add_component hypr
            add_component waybar
            ;;
    esac

    read -r -p "VS Code dotfiles if available? [Y/n] " answer
    case "${answer:-Y}" in
        y|Y|yes|YES)
            add_component vscode
            ;;
    esac
}

configure_profile() {
    case "$PROFILE" in

        complete)
            add_group core
            add_group developer
            add_group shell
            add_group editor
            add_group terminal
            add_group desktop

            add_component zsh
            add_component ghostty
            add_component nvim
            add_component hypr
            add_component waybar
            add_component vscode
            ;;

        developer)
            add_group core
            add_group developer
            add_group shell
            add_group editor
            add_group terminal

            add_component zsh
            add_component ghostty
            add_component nvim
            add_component vscode
            ;;

        minimal)
            add_group core
            add_group shell
            add_group editor

            add_component zsh
            add_component nvim
            ;;

        custom)
            custom_menu
            ;;

        *)
            mncm_die "Unknown profile: $PROFILE"
            ;;
    esac
}

load_packages() {
    ALL_PACKAGES=()

    for group in "${PACKAGE_GROUPS[@]}"; do

        local file="$REPO_ROOT/packages/$group.txt"

        [[ -f "$file" ]] ||
            mncm_die "Package group missing: $file"

        while IFS= read -r package; do

            [[ -n "$package" ]] || continue
            [[ "$package" != \#* ]] || continue

            if ! array_contains "$package" "${ALL_PACKAGES[@]}"; then
                ALL_PACKAGES+=("$package")
            fi

        done < "$file"

    done
}

calculate_missing() {
    MISSING_PACKAGES=()

    if [[ "$ARCH_HOST" != true ]]; then
        MISSING_PACKAGES=("${ALL_PACKAGES[@]}")
        return 0
    fi

    for package in "${ALL_PACKAGES[@]}"; do
        if ! pacman -Q "$package" >/dev/null 2>&1; then
            MISSING_PACKAGES+=("$package")
        fi
    done
}

show_plan() {
    mncm_heading "INSTALLATION PLAN"

    printf "\n"
    printf "Profile:          %s\n" "$PROFILE"
    printf "Package groups:   %s\n" "${#PACKAGE_GROUPS[@]}"
    printf "Packages total:   %s\n" "${#ALL_PACKAGES[@]}"
    printf "Packages missing: %s\n" "${#MISSING_PACKAGES[@]}"
    printf "Components:       %s\n" "${#COMPONENTS[@]}"

    if [[ "$WITH_DOTFILES" == true ]]; then
        printf "Dotfiles:         ENABLED\n"
        printf "Existing config:  BACKUP BEFORE DEPLOY\n"
    else
        printf "Dotfiles:         DISABLED\n"
    fi

    if [[ "$APPLY" == true ]]; then
        printf "Mode:             APPLY\n"
    else
        printf "Mode:             PLAN ONLY\n"
    fi

    printf "\n"

    if (( ${#PACKAGE_GROUPS[@]} > 0 )); then
        printf "${BOLD}PACKAGE GROUPS${RESET}\n\n"

        for group in "${PACKAGE_GROUPS[@]}"; do
            printf "  • %s\n" "$group"
        done

        printf "\n"
    fi

    if (( ${#MISSING_PACKAGES[@]} > 0 )); then
        printf "${BOLD}MISSING PACKAGES${RESET}\n\n"

        for package in "${MISSING_PACKAGES[@]}"; do
            printf "  • %s\n" "$package"
        done

        printf "\n"
    else
        mncm_ok "All selected packages are already installed"
        printf "\n"
    fi

    if [[ "$WITH_DOTFILES" == true ]] && (( ${#COMPONENTS[@]} > 0 )); then
        printf "${BOLD}DOTFILE COMPONENTS${RESET}\n\n"

        for component in "${COMPONENTS[@]}"; do
            printf "  • %s\n" "$component"
        done

        printf "\n"
    fi
}

install_packages() {
    if (( ${#MISSING_PACKAGES[@]} == 0 )); then
        mncm_ok "No package installation required"
        return 0
    fi

    mncm_heading "PACKAGE INSTALLATION"

    printf "\n"

    sudo pacman -S --needed "${MISSING_PACKAGES[@]}"

    mncm_ok "Package installation completed"
}

deploy_dotfiles() {
    [[ "$WITH_DOTFILES" == true ]] || return 0
    (( ${#COMPONENTS[@]} > 0 )) || return 0

    [[ -x "$SCRIPT_DIR/dotfiles.sh" ]] ||
        mncm_die "scripts/dotfiles.sh is missing or not executable."

    mncm_heading "DOTFILES"

    printf "\n"
    mncm_info "Dotfiles use the Phase 3 backup system."
    printf "\n"

    args=(--apply)

    for component in "${COMPONENTS[@]}"; do
        if [[ -d "$REPO_ROOT/$component" ]]; then
            args+=(--component "$component")
        else
            mncm_warn "$component not present in repository; skipping"
        fi
    done

    if (( ${#args[@]} == 1 )); then
        mncm_warn "No available dotfile components selected."
        return 0
    fi

    "$SCRIPT_DIR/dotfiles.sh" "${args[@]}"
}

verify_install() {
    mncm_heading "VERIFICATION"

    local failed=false

    for package in "${ALL_PACKAGES[@]}"; do
        if pacman -Q "$package" >/dev/null 2>&1; then
            mncm_ok "$package"
        else
            mncm_warn "$package missing"
            failed=true
        fi
    done

    printf "\n"

    if [[ "$failed" == true ]]; then
        mncm_warn "Verification completed with missing packages."
    else
        mncm_ok "Selected package set verified."
    fi
}

while (( $# > 0 )); do
    case "$1" in

        --profile)
            [[ $# -ge 2 ]] ||
                mncm_die "--profile requires a value."

            PROFILE="$2"

            case "$PROFILE" in
                complete|developer|minimal|custom)
                    ;;
                *)
                    mncm_die "Invalid profile: $PROFILE"
                    ;;
            esac

            shift 2
            ;;

        --apply)
            APPLY=true
            shift
            ;;

        --no-dotfiles)
            WITH_DOTFILES=false
            shift
            ;;

        --plan-anywhere)
            PLAN_ANYWHERE=true
            shift
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
            mncm_die "Unknown option: $1"
            ;;

    esac
done

mncm_banner

validate_system

if [[ -z "$PROFILE" ]]; then
    show_menu
fi

configure_profile
load_packages
calculate_missing
show_plan

if [[ "$APPLY" == false ]]; then

    mncm_heading "PLAN COMPLETE"

    mncm_ok "Nothing was installed."
    mncm_ok "No configuration was changed."

    if [[ "$ARCH_HOST" != true ]]; then
        mncm_info "Plan generated from a development host."
        mncm_info "Package state shown as planned rather than inspected."
    fi

    printf "\n"
    printf "Run the same profile with --apply when ready.\n"
    printf "\n"

    case "$PROFILE" in
        complete|developer|minimal)
            printf "  ./scripts/install.sh --profile %s --apply\n" "$PROFILE"
            ;;
        custom)
            printf "  ./scripts/install.sh --profile custom --apply\n"
            ;;
    esac

    printf "\n"

    exit 0
fi

mncm_heading "CONFIRM INSTALLATION"

mncm_warn "APPLY MODE ENABLED"
mncm_warn "Package installation may modify this Arch system."

if [[ "$WITH_DOTFILES" == true ]]; then
    mncm_info "Existing managed dotfiles will be backed up before deployment."
fi

printf "\n"

read -r -p "Continue with this installation plan? [y/N] " answer

case "$answer" in
    y|Y|yes|YES)
        ;;
    *)
        mncm_warn "Installation cancelled."
        exit 0
        ;;
esac

install_packages
deploy_dotfiles
verify_install

mncm_heading "MNCM INSTALL COMPLETE"

mncm_ok "Selected installation profile completed."

printf "\n"
printf "Profile: %s\n" "$PROFILE"
printf "\n"
printf "${BOLD}BUILD // BREAK // LEARN // REPEAT${RESET}\n"
printf "\n"
