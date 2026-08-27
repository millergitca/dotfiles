# MNCM LABS

## ARCH LINUX BOOTSTRAP

A reproducible Arch Linux development environment.

Arch Linux • Hyprland • Zsh • Ghostty • Neovim • VS Code • Docker

Website: https://mncm.ca/labs/

GitHub: https://github.com/millergitca/dotfiles

## Status

ACTIVE DEVELOPMENT

## About

MNCM Labs Arch Linux Bootstrap is designed to turn a fresh Arch Linux installation into a consistent development environment.

The goal:

Fresh Arch install → MNCM Bootstrap → Development workstation

## Current Stack

- Arch Linux
- Hyprland
- Waybar
- Zsh
- Ghostty
- Neovim
- VS Code
- Git
- GitHub CLI
- Docker
- ripgrep
- fd
- fzf
- jq

## Bootstrap Modes

Audit mode:

    ./scripts/bootstrap.sh

Apply mode:

    ./scripts/bootstrap.sh --apply

Audit mode does not intentionally install packages or deploy dotfiles.

## Roadmap

- [x] Dotfiles repository
- [x] Zsh configuration
- [x] Ghostty configuration
- [x] Neovim configuration
- [x] VS Code configuration
- [x] Hyprland overrides
- [x] Waybar configuration
- [x] Docker environment
- [x] Bootstrap framework
- [x] Safe configuration backups
- [x] Dotfile deployment
- [x] Component selection
- [x] Restore support
- [ ] Stable public installer

## Safe Dotfile Deployment

Phase 3 introduces modular configuration deployment.

Audit the repository configuration:

    ./scripts/dotfiles.sh

Deploy every available component:

    ./scripts/dotfiles.sh --apply --all

Deploy one component:

    ./scripts/dotfiles.sh --apply --component nvim

List backup snapshots:

    ./scripts/dotfiles.sh --backups

Existing managed configuration is backed up before deployment.

See:

    docs/DOTFILES.md

---

# Modular Installer

Phase 4 introduces installation profiles and modular package groups.

Interactive planner:

    ./scripts/install.sh

Complete profile:

    ./scripts/install.sh --profile complete

Developer profile:

    ./scripts/install.sh --profile developer

Minimal profile:

    ./scripts/install.sh --profile minimal

Custom profile:

    ./scripts/install.sh --profile custom

The installer defaults to planning mode.

Packages are not installed unless --apply is explicitly supplied.

Package definitions live in the packages directory.

See:

    docs/INSTALLER.md
    docs/PROFILES.md

---

# Health Check

Verify an Arch Linux environment with:

    ./scripts/health.sh

Post-install verification:

    ./scripts/verify.sh

# Documentation

Installation:

    docs/INSTALL.md

Troubleshooting:

    docs/TROUBLESHOOTING.md

Architecture:

    docs/ARCHITECTURE.md

Safety:

    docs/SAFETY.md

# Release Readiness

Run:

    ./scripts/release-check.sh

Current development version:

    0.7.0

---

# Warning

This project is under active development.

Review scripts before running them and keep backups of important configuration.
