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
    tree-sitter-cli
    jq
    iwd
    networkmanager

    ghostty
    zsh
    zsh-completions
    zsh-autosuggestions
    zsh-syntax-highlighting
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
    t2fanrd
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
    pipewire
    pipewire-pulse
    wireplumber
    rtkit
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

  # Remove legacy Powerlevel10k packages that conflict with the stable package.
  local legacy_packages=()

  for package in \
    zsh-theme-powerlevel10k-git \
    zsh-theme-powerlevel10k-git-debug
  do
    if pacman -Qq "$package" >/dev/null 2>&1; then
      legacy_packages+=("$package")
    fi
  done

  if ((${#legacy_packages[@]})); then
    info "Removing legacy Powerlevel10k packages"

    sudo pacman -Rns --noconfirm "${legacy_packages[@]}"
  fi

  if command -v yay >/dev/null 2>&1; then
    info "Installing AUR packages"
    yay -S --needed --noconfirm "${aur_packages[@]}"
    success "AUR packages installed"
  elif ((${#aur_packages[@]})); then
    warn "Skipping AUR packages because yay is not installed."
  fi

}
