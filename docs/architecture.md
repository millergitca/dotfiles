# MNCM Labs Architecture

MNCM Labs separates installation into layers.

## Layer 1 — Package Definitions

Directory:

    packages/

Package groups describe what should be installed.

Examples:

    core.txt
    developer.txt
    shell.txt
    editor.txt
    terminal.txt
    desktop.txt

## Layer 2 — Installer

    scripts/install.sh

Responsibilities:

- profile selection
- package planning
- package installation
- dotfile deployment orchestration
- confirmation before changes

## Layer 3 — Dotfiles

    scripts/dotfiles.sh

Responsibilities:

- audit
- backup
- component deployment
- restore

## Layer 4 — Verification

    scripts/health.sh
    scripts/verify.sh

Responsibilities:

- read-only system inspection
- package/tool checks
- configuration checks
- desktop checks
- Docker checks
- Neovim checks

## Layer 5 — Documentation

    docs/

Provides installation, safety, architecture and troubleshooting information.

## Design Principle

The project intentionally separates package installation from configuration deployment.

This makes it easier to test, audit and eventually replace individual pieces without rebuilding the entire bootstrap.
