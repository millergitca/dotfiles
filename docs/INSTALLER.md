# MNCM Labs Modular Installer

Phase 4 introduces installation profiles and modular package groups.

## Important

The installer currently targets an already-installed Arch Linux system.

It does not install Arch Linux itself.

It does not:

- partition disks
- format disks
- configure a bootloader
- install a kernel
- create users
- replace an existing operating system

## Default Behavior

Running:

    ./scripts/install.sh

opens the profile selector and creates an installation plan.

Planning mode does not intentionally install packages or deploy configuration.

## Profiles

### MNCM Complete

Includes:

- core CLI tools
- development languages
- Docker
- Zsh
- Neovim
- Ghostty
- Hyprland
- Waybar
- Hyprpaper
- Hyprlock
- Hypridle
- available MNCM dotfiles

Plan:

    ./scripts/install.sh --profile complete

Apply:

    ./scripts/install.sh --profile complete --apply

### Developer

Includes:

- core CLI tools
- development languages
- Docker
- Zsh
- Neovim
- Ghostty
- available development dotfiles

It does not install the full Hyprland package group.

Plan:

    ./scripts/install.sh --profile developer

### Minimal

Includes:

- core CLI tools
- Zsh
- Neovim
- available shell/editor dotfiles

Plan:

    ./scripts/install.sh --profile minimal

### Custom

Allows individual package groups to be selected.

Run:

    ./scripts/install.sh --profile custom

## Package Groups

Package definitions live in:

    packages/core.txt
    packages/developer.txt
    packages/shell.txt
    packages/editor.txt
    packages/desktop.txt
    packages/terminal.txt

Keeping package definitions separate from installer logic makes the project easier to maintain.

## Dotfiles

Phase 4 uses the Phase 3 dotfile deployment system.

Existing managed files are backed up before deployment.

Dotfile deployment can be disabled:

    ./scripts/install.sh --profile complete --no-dotfiles

## Safety

Package installation requires both:

1. --apply
2. interactive confirmation

Dotfile deployment has its own confirmation and backup process.

The installer refuses to run directly as root.

## Current Limitations

The installer currently uses official pacman package groups only.

AUR package management is intentionally not automated yet.

The installer is not yet considered a stable public release.

Do not publish a remote curl-to-shell installer until testing and verification are complete.
