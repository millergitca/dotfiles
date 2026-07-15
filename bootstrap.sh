#!/usr/bin/env bash

set -Eeuo pipefail

export DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

# shellcheck source=lib/directories.sh
source "$DOTFILES_DIR/lib/directories.sh"

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
# Dotfiles installation
# ------------------------------------------------------------

install_dotfiles() {
  info "Installing tracked dotfiles"

  chmod +x "$DOTFILES_DIR/install.sh"
  "$DOTFILES_DIR/install.sh"

  success "Dotfiles installed"
}

# ------------------------------------------------------------
# Git defaults
# ------------------------------------------------------------

configure_git() {
  info "Applying non-personal Git defaults"

  git config --global init.defaultBranch main
  git config --global core.editor nvim
  git config --global core.autocrlf input
  git config --global fetch.prune true
  git config --global push.autoSetupRemote true
  git config --global rerere.enabled true

  if ! git config --global user.name >/dev/null; then
    warn "Git user.name is not configured."
    warn 'Set it later with: git config --global user.name "Your Name"'
  fi

  if ! git config --global user.email >/dev/null; then
    warn "Git user.email is not configured."
    warn 'Set it later with: git config --global user.email "you@example.com"'
  fi

  success "Git defaults configured"
}

# ------------------------------------------------------------
# Verification
# ------------------------------------------------------------

verify_setup() {
  info "Verifying installed tools"

  local tools=(
    git
    gh
    ghostty
    zsh
    nvim
    tmux
    python
    node
    npm
    java
    go
    rustc
    cargo
    docker
    brightnessctl
  )

  local missing=0

  for tool in "${tools[@]}"; do
    if command_exists "$tool"; then
      printf '  %-18s %s\n' "$tool" "OK"
    else
      printf '  %-18s %s\n' "$tool" "MISSING"
      missing=1
    fi
  done

  if ((missing)); then
    warn "Some expected tools are missing. Review the log:"
    warn "$BOOTSTRAP_LOG_FILE"
  else
    success "All expected tools were found"
  fi
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
  configure_shell
  configure_docker
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
