#!/usr/bin/env bash

set -Eeuo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$HOME/.local/state/dotfiles-bootstrap"
LOG_FILE="$LOG_DIR/bootstrap-$(date +%Y%m%d-%H%M%S).log"

mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

# ------------------------------------------------------------
# Shared libraries
# ------------------------------------------------------------

# shellcheck source=lib/logging.sh
source "$DOTFILES_DIR/lib/logging.sh"

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# ------------------------------------------------------------
# Preflight
# ------------------------------------------------------------

preflight() {
  info "Running preflight checks"

  [[ -f /etc/arch-release ]] ||
    fail "This bootstrap currently supports Arch Linux only."

  [[ "$EUID" -ne 0 ]] ||
    fail "Run this script as your normal user, not with sudo."

  command_exists sudo ||
    fail "sudo is required."

  command_exists pacman ||
    fail "pacman is required."

  [[ -f "$DOTFILES_DIR/install.sh" ]] ||
    fail "install.sh was not found in $DOTFILES_DIR."

  success "Preflight checks passed"
}

# ------------------------------------------------------------
# Package installation
# ------------------------------------------------------------

install_packages() {
  info "Updating Arch Linux"

  sudo pacman -Syu

  local packages=(
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

    ghostty
    zsh
    zsh-completions
    zsh-autosuggestions
    zsh-syntax-highlighting
    powerlevel10k
    ttf-jetbrains-mono-nerd

    neovim
    tmux
    ripgrep
    fd
    fzf
    bat
    eza
    zoxide
    btop
    fastfetch
    wl-clipboard

    python
    python-pip
    python-virtualenv
    nodejs
    npm
    jdk-openjdk
    go
    rust
    gcc
    clang
    cmake
    make
    gdb
    lldb

    docker
    docker-compose

    brightnessctl
    playerctl
    pavucontrol
    network-manager-applet
    blueman

    zathura
    zathura-pdf-mupdf
  )

  info "Installing core packages"

  sudo pacman -S --needed "${packages[@]}"

  success "Core packages installed"
}

# ------------------------------------------------------------
# Shell setup
# ------------------------------------------------------------

configure_shell() {
  info "Configuring Zsh"

  local zsh_path
  zsh_path="$(command -v zsh)"

  if [[ "$SHELL" != "$zsh_path" ]]; then
    chsh -s "$zsh_path"
    warn "Your login shell was changed to Zsh."
    warn "Log out and back in after bootstrap completes."
  else
    success "Zsh is already the login shell"
  fi
}

# ------------------------------------------------------------
# Docker setup
# ------------------------------------------------------------

configure_docker() {
  info "Configuring Docker"

  sudo systemctl enable --now docker.service

  if ! id -nG "$USER" | tr ' ' '\n' | grep -qx docker; then
    sudo usermod -aG docker "$USER"
    warn "You were added to the docker group."
    warn "Log out and back in before using Docker without sudo."
  else
    success "User is already in the docker group"
  fi
}

# ------------------------------------------------------------
# Development directories
# ------------------------------------------------------------

create_directories() {
  info "Creating development directories"

  mkdir -p \
    "$HOME/Projects/Personal" \
    "$HOME/Projects/University" \
    "$HOME/Projects/OpenSource" \
    "$HOME/Projects/Experiments" \
    "$HOME/University/Notes" \
    "$HOME/University/Assignments" \
    "$HOME/University/Resources" \
    "$HOME/University/Templates" \
    "$HOME/Scripts"

  success "Development directories created"
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
    warn "$LOG_FILE"
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
  printf '\nLog file:\n  %s\n' "$LOG_FILE"
  printf '\nRecommended final step:\n  Log out and back in once.\n'
}

main "$@"
