<div align="center">

# MNCM LABS

## ARCH LINUX BOOTSTRAP

**A reproducible Arch Linux development environment.**

Arch Linux • Hyprland • Zsh • Ghostty • Neovim • VS Code • Docker

[MNCM Labs](https://mncm.ca/labs/) • [MNCM](https://mncm.ca) • [GitHub](https://github.com/millergitca/dotfiles)

---

**STATUS: ACTIVE DEVELOPMENT**

</div>

# About

MNCM Labs Arch Linux Bootstrap is a project for turning a fresh
Arch Linux installation into a consistent development environment.

Instead of manually rebuilding the same shell, terminal, editor,
desktop and development configuration every time, the bootstrap
will automate the process while keeping configuration under
version control.

The goal is simple:

**Fresh Arch install → MNCM Bootstrap → Development workstation**

---

# Stack

| Component | Purpose |
|---|---|
| Arch Linux | Operating system |
| Hyprland | Wayland compositor |
| Waybar | Status bar |
| Zsh | Shell |
| Ghostty | Terminal |
| Neovim | Terminal editor / IDE |
| VS Code | GUI development environment |
| Git | Version control |
| GitHub CLI | GitHub workflow |
| Docker | Containers |
| ripgrep | Code searching |
| fd | File searching |
| fzf | Fuzzy finding |
| jq | JSON processing |

---

# Project Principles

## Reproducible

A fresh system should be able to reach a predictable development
state without manually repeating dozens of setup steps.

## Modular

Shell, terminal, editor, desktop and developer tooling should be
independently maintainable.

## Safe

Existing configuration should be detected and backed up before
replacement.

## Understandable

Scripts should remain readable enough to learn from and modify.

## Open Source

Development happens publicly through GitHub.

---

# Bootstrap

The bootstrap currently has two modes.

## Audit Mode

Command:

    ./scripts/bootstrap.sh

This is the default.

Audit mode checks the system and reports what is installed or
missing.

It does not intentionally install packages or deploy dotfiles.

## Apply Mode

Command:

    ./scripts/bootstrap.sh --apply

Apply mode enables supported installation operations.

The project is still under development, so review the script before
using Apply Mode.

---

# What It Checks

The current bootstrap checks:

- Arch Linux detection
- pacman availability
- non-root execution
- base development packages
- Docker
- Zsh
- Ghostty
- Neovim
- VS Code
- Hyprland
- configuration directories
- repository components

---

# Repository Structure

    dotfiles/
    ├── README.md
    ├── scripts/
    │   └── bootstrap.sh
    ├── docs/
    │   ├── ROADMAP.md
    │   └── SAFETY.md
    ├── ghostty/
    ├── hypr/
    ├── nvim/
    ├── waybar/
    ├── zsh/
    └── vscode/

---

# Current Package Set

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
    ripgrep
    fd
    fzf
    docker

---

# Roadmap

## Foundation

- [x] Dotfiles repository
- [x] Zsh configuration
- [x] Ghostty configuration
- [x] Neovim configuration
- [x] VS Code configuration
- [x] Hyprland overrides
- [x] Waybar configuration
- [x] Git configuration
- [x] Docker environment

## Bootstrap

- [x] Bootstrap framework
- [x] Audit mode
- [x] Explicit apply mode
- [x] Arch detection
- [x] Package inspection
- [ ] Automatic configuration backups
- [ ] Dotfile deployment
- [ ] Component selection
- [ ] Package groups
- [ ] Post-install verification
- [ ] Restore / rollback

## Documentation

- [x] Project README
- [x] Roadmap
- [x] Safety documentation
- [ ] Installation guide
- [ ] Customization guide
- [ ] Troubleshooting
- [ ] Screenshots

## Future

- [ ] Stable tagged release
- [ ] Automated testing
- [ ] Health checks
- [ ] Update command
- [ ] Restore command
- [ ] Safe remote installer

---

# Installation

There is currently **no public one-line installer**.

For development:

    git clone https://github.com/millergitca/dotfiles.git
    cd dotfiles
    ./scripts/bootstrap.sh

The eventual public installer will be released through:

**https://mncm.ca/labs/**

after the bootstrap has been sufficiently tested.

---

# Warning

MNCM Labs Arch Linux Bootstrap is under active development.

Always review scripts before running them and maintain backups of
important files and configuration.

---

# MNCM Labs

MNCM Labs is the software and technology side of MNCM.

**BUILD // BREAK // LEARN // REPEAT**

https://mncm.ca/labs/

<div align="center">

---

© MNCM

**LIVE. FIGHT. ESCAPE. BUILD.**

</div>
