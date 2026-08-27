#!/usr/bin/env bash

set -Eeuo pipefail

VERSION="0.2.0"

REPO_ROOT="$(
    cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
    pwd
)"

BACKUP_ROOT="${XDG_STATE_HOME:-$HOME/.local/state}/mncm-labs/backups"

MODE="audit"
SELECTED_COMPONENTS=()
RESTORE_PATH=""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

COMPONENTS=(
    zsh
    ghostty
    nvim
    hypr
    waybar
    vscode
)

info() {
    printf "${BLUE}::${RESET} %s\n" "$*"
}

ok() {
    printf "${GREEN}✓${RESET} %s\n" "$*"
}

warn() {
    printf "${YELLOW}!${RESET} %s\n" "$*"
}

die() {
    printf "${RED}✗${RESET} %s\n" "$*" >&2
    exit 1
}

heading() {
    printf "\n${BOLD}%s${RESET}\n" "$1"
    printf '%*s\n' "${#1}" '' | tr ' ' '-'
}

usage() {
    cat <<EOF

MNCM Labs Dotfile Deployment v${VERSION}

Usage:

  ./scripts/dotfiles.sh

      Audit all available components.
      No files are modified.

  ./scripts/dotfiles.sh --apply --all

      Back up existing files and deploy all components.

  ./scripts/dotfiles.sh --apply --component nvim

      Deploy one component.

  ./scripts/dotfiles.sh --apply --component zsh --component ghostty

      Deploy multiple selected components.

  ./scripts/dotfiles.sh --list

      List available components.

  ./scripts/dotfiles.sh --backups

      List available backup snapshots.

  ./scripts/dotfiles.sh --restore PATH

      Restore a specific backup snapshot.

  ./scripts/dotfiles.sh --version

      Display version.

  ./scripts/dotfiles.sh --help

      Display this help.

Safety:

  Audit mode is the default.

  Deployment requires --apply.

  Existing destination files are backed up before replacement.

  This tool does not delete unrelated files from your home directory.

EOF
}

list_components() {
    printf "\nAvailable components:\n\n"

    for component in "${COMPONENTS[@]}"; do
        if [[ -d "$REPO_ROOT/$component" ]]; then
            printf "  ✓ %s\n" "$component"
        else
            printf "  - %s (not present in repository)\n" "$component"
        fi
    done

    printf "\n"
}

list_backups() {
    printf "\nMNCM Labs backups:\n\n"

    if [[ ! -d "$BACKUP_ROOT" ]]; then
        printf "  No backups found.\n\n"
        exit 0
    fi

    found=false

    while IFS= read -r backup; do
        found=true
        printf "  %s\n" "$backup"
    done < <(
        find "$BACKUP_ROOT" \
            -mindepth 1 \
            -maxdepth 1 \
            -type d \
            -print |
        sort -r
    )

    if [[ "$found" == false ]]; then
        printf "  No backups found.\n"
    fi

    printf "\n"
}

validate_environment() {
    [[ "$(id -u)" -ne 0 ]] ||
        die "Do not run dotfile deployment as root."

    [[ -d "$HOME" ]] ||
        die "HOME is not available."

    command -v rsync >/dev/null 2>&1 ||
        die "rsync is required."

    ok "Environment validated"
}

component_exists() {
    local component="$1"

    for known in "${COMPONENTS[@]}"; do
        [[ "$component" == "$known" ]] && return 0
    done

    return 1
}

source_dir() {
    printf '%s/%s' "$REPO_ROOT" "$1"
}

audit_component() {
    local component="$1"
    local source

    source="$(source_dir "$component")"

    heading "$component"

    if [[ ! -d "$source" ]]; then
        warn "Component not currently present in repository."
        return 0
    fi

    ok "Source: $source"

    local count

    count="$(
        find "$source" \
            -type f \
            -o -type l |
        wc -l |
        tr -d ' '
    )"

    info "Managed files: $count"

    while IFS= read -r relative; do
        [[ -n "$relative" ]] || continue

        local destination="$HOME/$relative"

        if [[ -L "$destination" ]]; then
            info "SYMLINK  $relative"
        elif [[ -f "$destination" ]]; then
            info "EXISTS   $relative"
        elif [[ -d "$destination" ]]; then
            info "DIR      $relative"
        else
            info "NEW      $relative"
        fi

    done < <(
        cd "$source"
        find . \
            \( -type f -o -type l \) \
            -print |
        sed 's#^\./##' |
        sort
    )
}

create_backup() {
    local timestamp
    timestamp="$(date +%Y%m%d-%H%M%S)"

    CURRENT_BACKUP="$BACKUP_ROOT/$timestamp"

    mkdir -p "$CURRENT_BACKUP/files"

    cat > "$CURRENT_BACKUP/manifest.txt" <<MANIFEST
MNCM Labs Dotfile Backup
Created: $(date)
Repository: $REPO_ROOT
Host: $(hostname)
User: $(id -un)

Components:
MANIFEST

    ok "Backup snapshot: $CURRENT_BACKUP"
}

backup_destination() {
    local relative="$1"
    local destination="$HOME/$relative"
    local backup="$CURRENT_BACKUP/files/$relative"

    if [[ ! -e "$destination" && ! -L "$destination" ]]; then
        return 0
    fi

    mkdir -p "$(dirname "$backup")"

    if [[ -d "$destination" && ! -L "$destination" ]]; then
        rsync -a "$destination/" "$backup/"
    else
        cp -a "$destination" "$backup"
    fi

    printf '%s\n' "$relative" \
        >> "$CURRENT_BACKUP/backed-up-paths.txt"
}

deploy_component() {
    local component="$1"
    local source

    source="$(source_dir "$component")"

    heading "Deploying $component"

    if [[ ! -d "$source" ]]; then
        warn "Component missing from repository. Skipped."
        return 0
    fi

    printf '%s\n' "$component" \
        >> "$CURRENT_BACKUP/manifest.txt"

    while IFS= read -r relative; do
        [[ -n "$relative" ]] || continue

        backup_destination "$relative"

    done < <(
        cd "$source"
        find . \
            \( -type f -o -type l \) \
            -print |
        sed 's#^\./##' |
        sort
    )

    rsync \
        -a \
        --itemize-changes \
        "$source/" \
        "$HOME/"

    ok "$component deployed"
}

restore_snapshot() {
    local snapshot="$1"

    [[ -d "$snapshot" ]] ||
        die "Backup snapshot does not exist: $snapshot"

    [[ -d "$snapshot/files" ]] ||
        die "Invalid backup snapshot."

    heading "RESTORE"

    warn "Restore will copy backed-up files into:"
    printf "  %s\n\n" "$HOME"

    printf "Snapshot:\n  %s\n\n" "$snapshot"

    read -r -p "Restore this snapshot? [y/N] " answer

    case "$answer" in
        y|Y|yes|YES)
            ;;
        *)
            warn "Restore cancelled."
            exit 0
            ;;
    esac

    rsync \
        -a \
        --itemize-changes \
        "$snapshot/files/" \
        "$HOME/"

    ok "Backup restored"

    printf "\n"
    warn "Files created by a newer deployment but absent from the backup"
    warn "are intentionally NOT deleted automatically."
    printf "\n"
}

while (( $# > 0 )); do
    case "$1" in

        --apply)
            MODE="apply"
            shift
            ;;

        --all)
            SELECTED_COMPONENTS=("${COMPONENTS[@]}")
            shift
            ;;

        --component)
            [[ $# -ge 2 ]] ||
                die "--component requires a name."

            component="$2"

            component_exists "$component" ||
                die "Unknown component: $component"

            SELECTED_COMPONENTS+=("$component")
            shift 2
            ;;

        --list)
            list_components
            exit 0
            ;;

        --backups)
            list_backups
            exit 0
            ;;

        --restore)
            [[ $# -ge 2 ]] ||
                die "--restore requires a backup path."

            RESTORE_PATH="$2"
            shift 2
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
            die "Unknown option: $1"
            ;;

    esac
done

printf "\n"
printf "${RED}${BOLD}MNCM LABS${RESET}\n"
printf "${BOLD}SAFE DOTFILE DEPLOYMENT${RESET}\n"
printf "Version %s\n" "$VERSION"
printf "\n"

validate_environment

if [[ -n "$RESTORE_PATH" ]]; then
    restore_snapshot "$RESTORE_PATH"
    exit 0
fi

if (( ${#SELECTED_COMPONENTS[@]} == 0 )); then
    SELECTED_COMPONENTS=("${COMPONENTS[@]}")
fi

if [[ "$MODE" == "audit" ]]; then

    info "AUDIT MODE"
    info "No files will be modified."

    for component in "${SELECTED_COMPONENTS[@]}"; do
        audit_component "$component"
    done

    heading "AUDIT COMPLETE"

    ok "No configuration was changed."

    printf "\n"
    printf "To deploy everything:\n\n"
    printf "  ./scripts/dotfiles.sh --apply --all\n\n"

    printf "To deploy one component:\n\n"
    printf "  ./scripts/dotfiles.sh --apply --component nvim\n\n"

    exit 0
fi

warn "APPLY MODE"
warn "Existing managed files will be backed up first."

printf "\nSelected components:\n\n"

for component in "${SELECTED_COMPONENTS[@]}"; do
    printf "  • %s\n" "$component"
done

printf "\n"

read -r -p "Continue with deployment? [y/N] " answer

case "$answer" in
    y|Y|yes|YES)
        ;;
    *)
        warn "Deployment cancelled."
        exit 0
        ;;
esac

create_backup

for component in "${SELECTED_COMPONENTS[@]}"; do
    deploy_component "$component"
done

heading "DEPLOYMENT COMPLETE"

ok "Selected components deployed."
ok "Backup created at:"
printf "  %s\n" "$CURRENT_BACKUP"

printf "\nRestore with:\n\n"
printf "  ./scripts/dotfiles.sh --restore \"%s\"\n\n" \
    "$CURRENT_BACKUP"
