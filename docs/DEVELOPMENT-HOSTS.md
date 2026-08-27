# MNCM Labs Development Hosts

MNCM Labs targets Arch Linux for installation.

Development and repository maintenance can happen from other operating systems.

## macOS

macOS is recognized as a development host.

Run:

    ./scripts/health.sh

Arch-specific checks are reported as skipped rather than failed.

To preview an Arch installation profile from macOS:

    ./scripts/install.sh --profile complete --plan-anywhere

## Apply Mode

Apply Mode is never enabled by --plan-anywhere.

This command is blocked on macOS:

    ./scripts/install.sh --profile complete --apply

The installer requires an actual supported Arch Linux host before package installation can occur.

## Why

This separation allows the MNCM Labs project to be developed and validated from macOS without pretending macOS is an Arch Linux installation target.
