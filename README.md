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
- [ ] Safe configuration backups
- [ ] Dotfile deployment
- [ ] Component selection
- [ ] Restore support
- [ ] Stable public installer

## Warning

This project is under active development.

Review scripts before running them and keep backups of important configuration.
