# MNCM Labs Installation Guide

MNCM Labs currently targets an existing Arch Linux installation.

It does not install Arch itself.

## 1. Clone

    git clone https://github.com/millergitca/dotfiles.git
    cd dotfiles

## 2. Run Health Check

    ./scripts/health.sh

Warnings are expected on a fresh system.

## 3. Preview Installation

Complete profile:

    ./scripts/install.sh --profile complete

Developer profile:

    ./scripts/install.sh --profile developer

Minimal profile:

    ./scripts/install.sh --profile minimal

No packages are installed during planning mode.

## 4. Review

Read the installation plan before continuing.

## 5. Apply

When ready:

    ./scripts/install.sh --profile complete --apply

The installer asks for confirmation before package installation.

The Phase 3 dotfile system also backs up managed configuration before deployment.

## 6. Verify

After installation:

    ./scripts/health.sh

or:

    ./scripts/verify.sh

## Backups

List backups:

    ./scripts/dotfiles.sh --backups

Restore:

    ./scripts/dotfiles.sh --restore /path/to/backup

## Important

Always review scripts before running Apply Mode.
