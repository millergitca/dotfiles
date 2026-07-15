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
