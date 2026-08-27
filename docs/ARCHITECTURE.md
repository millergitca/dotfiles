# MNCM Labs Architecture

MNCM Labs is a modular Arch Linux bootstrap and development-environment project.

The project is intentionally separated into layers so package installation, configuration deployment, verification, and release management can be tested independently.

---

## Project Structure

    .
    ├── packages/
    ├── scripts/
    │   ├── lib/
    │   ├── bootstrap.sh
    │   ├── install.sh
    │   ├── dotfiles.sh
    │   ├── health.sh
    │   ├── verify.sh
    │   ├── release-check.sh
    │   └── release.sh
    ├── docs/
    ├── tests/
    ├── .github/
    │   └── workflows/
    ├── VERSION
    ├── CHANGELOG.md
    └── README.md

---

# 1. Package Definitions

Package definitions live in:

    packages/

Current groups include:

    core.txt
    developer.txt
    shell.txt
    editor.txt
    terminal.txt
    desktop.txt

These files define package groups separately from installer logic.

This allows packages to be added, removed, or reorganized without rewriting the main installer.

---

# 2. Bootstrap Layer

Primary bootstrap entry:

    scripts/bootstrap.sh

The bootstrap layer provides the foundation for the MNCM Labs environment.

It is kept separate from the modular installer so bootstrap behavior can evolve independently.

---

# 3. Installer Layer

Primary installer:

    scripts/install.sh

The installer is responsible for:

- operating-system detection
- installation profile selection
- package-group selection
- installation planning
- package installation
- dotfile deployment orchestration
- user confirmation before changes

Supported profiles include:

    complete
    developer
    minimal
    custom

Planning is the default behavior.

Package installation requires explicit Apply Mode:

    --apply

Apply Mode is restricted to supported Arch Linux hosts.

---

# 4. Development Hosts

MNCM Labs can be developed from systems other than Arch Linux.

macOS is currently recognized as a development host.

A development host can:

- run repository validation
- run health checks
- validate Bash syntax
- inspect documentation
- generate installation plans

Example:

    ./scripts/install.sh --profile complete --plan-anywhere

A development host cannot use Arch package Apply Mode.

This separation prevents development testing from being mistaken for an actual Arch installation.

---

# 5. Dotfile Layer

Dotfile management is handled by:

    scripts/dotfiles.sh

The dotfile system provides:

- audit mode
- component selection
- existing configuration detection
- timestamped backups
- modular deployment
- restore support

Supported component names include:

    zsh
    ghostty
    nvim
    hypr
    waybar
    vscode

Audit mode is the default.

Example:

    ./scripts/dotfiles.sh

Deployment requires explicit Apply Mode.

Example:

    ./scripts/dotfiles.sh --apply --component nvim

Existing managed configuration is backed up before replacement.

---

# 6. Health Layer

System inspection is handled by:

    scripts/health.sh

The health system checks available development tools and host-specific functionality.

Examples include:

- Git
- GitHub CLI
- Zsh
- Neovim
- Ghostty
- Docker
- ripgrep
- fd
- fzf
- jq
- rsync

On Arch Linux it can additionally inspect:

- pacman
- Hyprland
- Waybar
- Wayland
- Arch-specific configuration

Arch-only checks are skipped on macOS development hosts.

---

# 7. Verification Layer

Post-install verification is provided by:

    scripts/verify.sh

Verification uses the health-check system to inspect the resulting environment after installation.

This layer is intentionally separate from installation so a system can be inspected without modifying it.

---

# 8. Shared Library

Reusable shell functionality lives beneath:

    scripts/lib/

The current shared library includes:

    scripts/lib/common.sh

Shared presentation and utility functions belong here instead of being duplicated throughout installer scripts.

---

# 9. Testing Layer

Repository validation lives in:

    tests/

The primary validation entry point is:

    tests/check.sh

Validation checks include:

- required repository files
- executable permissions
- Bash syntax
- package-definition files
- semantic version format
- ShellCheck error-level diagnostics
- Git whitespace errors

The test layer does not install packages.

---

# 10. Continuous Integration

GitHub Actions configuration lives in:

    .github/workflows/

The primary workflow is:

    Validate MNCM Labs

CI automatically validates repository changes pushed to the main branch and pull requests targeting main.

The workflow runs repository validation in a clean Linux environment.

---

# 11. Release Layer

Release readiness is checked by:

    scripts/release-check.sh

Release tagging is handled by:

    scripts/release.sh

Project version information lives in:

    VERSION

Release history lives in:

    CHANGELOG.md

A successful repository-level release check does not automatically mean the installer has passed real Arch Linux installation testing.

Hardware or virtual-machine testing is still required before declaring a stable production release.

---

# 12. Safety Model

MNCM Labs follows several safety principles.

## Plan Before Apply

Installation planning is available without changing the system.

## Explicit Apply

Package installation requires:

    --apply

## Arch-Only Installation

Development hosts cannot accidentally invoke Arch package installation.

## Dotfile Backups

Managed configuration is backed up before deployment.

## No Automatic Disk Operations

The current project does not:

- partition disks
- format disks
- configure filesystems
- replace operating systems
- install bootloaders

## No Forced Remote Execution

The current public workflow does not rely on blindly piping a remote script directly into a shell.

Users can clone and inspect the repository first.

---

# 13. Design Philosophy

MNCM Labs favors:

- modularity
- inspectability
- explicit changes
- safe defaults
- backups
- validation
- reproducibility

The long-term goal is a reliable Arch Linux development-environment bootstrap that remains understandable enough for users to inspect what it will do before allowing it to modify their system.

---

MNCM LABS

BUILD // BREAK // LEARN // REPEAT
