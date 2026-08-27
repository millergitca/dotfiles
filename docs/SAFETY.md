# MNCM Labs Bootstrap Safety

MNCM Labs is designed around conservative system modification.

## Audit Mode

The default command is:

    ./scripts/bootstrap.sh

This performs system inspection.

It does not intentionally install packages or deploy configuration.

## Apply Mode

System modification requires:

    ./scripts/bootstrap.sh --apply

Package installation also requires interactive confirmation.

## Current Safety Restrictions

The bootstrap currently does NOT:

- overwrite existing dotfiles
- delete user configuration
- remove packages
- repartition disks
- modify filesystems
- modify the bootloader
- change kernel configuration
- automatically install AUR packages
- automatically deploy Hyprland configuration
- automatically replace Neovim configuration
- automatically replace shell configuration

## Planned Dotfile Safety

Before configuration deployment is enabled, the bootstrap will add:

1. Existing configuration detection
2. Timestamped backups
3. Component-level installation
4. Conflict reporting
5. Post-install validation
6. Restore functionality

## Remote Installation

A remote installation command will not be published until the
bootstrap has been sufficiently tested and released as a stable
version.
