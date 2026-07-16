#!/usr/bin/env bash

set -Eeuo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR

# shellcheck source=lib/constants.sh
source "$DOTFILES_DIR/lib/constants.sh"

exec > >(tee -a "$BOOTSTRAP_LOG_FILE") 2>&1

# ------------------------------------------------------------
# Shared libraries
# ------------------------------------------------------------

# shellcheck source=lib/logging.sh
source "$DOTFILES_DIR/lib/logging.sh"

# shellcheck source=lib/system.sh
source "$DOTFILES_DIR/lib/system.sh"

# shellcheck source=lib/packages.sh
source "$DOTFILES_DIR/lib/packages.sh"

# shellcheck source=lib/shell.sh
source "$DOTFILES_DIR/lib/shell.sh"

# shellcheck source=lib/docker.sh
source "$DOTFILES_DIR/lib/docker.sh"

# shellcheck source=lib/audio.sh
source "$DOTFILES_DIR/lib/audio.sh"

# shellcheck source=lib/directories.sh
source "$DOTFILES_DIR/lib/directories.sh"

# shellcheck source=lib/git.sh
source "$DOTFILES_DIR/lib/git.sh"

# shellcheck source=lib/dotfiles.sh
source "$DOTFILES_DIR/lib/dotfiles.sh"

# shellcheck source=lib/ml4w.sh
source "$DOTFILES_DIR/lib/ml4w.sh"

# shellcheck source=lib/t2.sh
source "$DOTFILES_DIR/lib/t2.sh"

# shellcheck source=lib/verify.sh
source "$DOTFILES_DIR/lib/verify.sh"

# ------------------------------------------------------------
# Preflight
# ------------------------------------------------------------

preflight() {
  info "Running preflight checks"

  is_arch_linux ||
    fail "This bootstrap currently supports Arch Linux only."

  ! is_root ||
    fail "Run this script as your normal user, not with sudo."

  require_command sudo
  require_command pacman

  [[ -f "$DOTFILES_DIR/install.sh" ]] ||
    fail "install.sh was not found in $DOTFILES_DIR."

  success "Preflight checks passed"
}

# ------------------------------------------------------------
# Main
# ------------------------------------------------------------

main() {
  printf '\n'
  printf '====================================================\n'
  printf '     Miller Arch Development Workstation Setup\n'
  printf '====================================================\n'

  preflight
  install_packages
  configure_networking
  configure_ml4w
  configure_t2
  configure_shell
  configure_docker
  configure_audio
  create_directories
  configure_git
  install_dotfiles
  verify_setup

  printf '\n'
  printf '====================================================\n'
  printf ' Bootstrap complete\n'
  printf '====================================================\n'
  printf '\nLog file:\n  %s\n' "$BOOTSTRAP_LOG_FILE"
  printf '\nRecommended final step:\n  Log out and back in once.\n'
}

main "$@"
