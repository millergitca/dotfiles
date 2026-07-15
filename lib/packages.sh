#!/usr/bin/env bash

# Arch Linux package installation for the development workstation.
#
# This file expects lib/logging.sh to be sourced first.

install_packages() {
  info "Updating Arch Linux"

  sudo pacman -Syu

  local packages=(
    base-devel
    git
    less
    github-cli
    openssh
    curl
    wget
    rsync
    zip
    unzip
    tree
    jq
    iwd
    networkmanager

    ghostty
    zsh
    zsh-completions
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-theme-powerlevel10k
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

  local aur_packages=(
	zsh-theme-powerlevel10k
  )

  info "Installing core packages"

  sudo pacman -S --needed "${packages[@]}"

  success "Core packages installed"

  if command -v yay >/dev/null 2>&1; then
	info "Installing AUR packages"
	yay -S --needed --noconfirm "${aur_packages[@]}"
	success "AUR packages installed"
  else
	fail "yay is required to install AUR packages."
  fi

}
