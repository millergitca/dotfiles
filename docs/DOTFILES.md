# MNCM Labs Safe Dotfile Deployment

Phase 3 adds a conservative deployment system for configuration managed by the repository.

## Supported Components

The deployment tool recognizes:

- zsh
- ghostty
- nvim
- hypr
- waybar
- vscode

Only components that currently exist in the repository are deployed.

## Audit Mode

Audit mode is the default:

    ./scripts/dotfiles.sh

It reports:

- which components exist
- which files are managed
- whether target files already exist
- which paths would be new

Audit mode does not intentionally modify configuration.

## Deploy Everything

    ./scripts/dotfiles.sh --apply --all

Before deployment, the tool:

1. verifies that it is not running as root
2. verifies rsync is installed
3. displays selected components
4. requests confirmation
5. creates a timestamped backup
6. copies existing managed files into the backup
7. deploys repository configuration

## Deploy One Component

Example:

    ./scripts/dotfiles.sh --apply --component nvim

Multiple components can be selected:

    ./scripts/dotfiles.sh --apply --component zsh --component ghostty

## Backups

Backups are stored beneath:

    ~/.local/state/mncm-labs/backups/

or:

    $XDG_STATE_HOME/mncm-labs/backups/

when XDG_STATE_HOME is configured.

List backups:

    ./scripts/dotfiles.sh --backups

Each backup contains:

- timestamp
- manifest
- backed-up paths
- copies of existing managed files

## Restore

Restore a snapshot with:

    ./scripts/dotfiles.sh --restore /path/to/backup

Restore requires confirmation.

The restore process intentionally does not delete files that are not part of the backup.

## Safety Model

The deployment tool does not:

- run automatically from the bootstrap
- delete unrelated files
- delete configuration not represented in the repository
- repartition disks
- modify filesystems
- modify the bootloader
- install AUR packages
- run as root
- deploy without explicit apply mode
- deploy without interactive confirmation

## Important Limitation

The current restore mechanism restores files that existed before deployment.

It does not automatically remove files that were newly created by a deployment.

A future phase can add a transaction manifest that allows exact rollback of newly created files as well.
