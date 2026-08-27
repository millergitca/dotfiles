# MNCM Labs Troubleshooting

## Installer Says Not Arch Linux

MNCM Labs currently supports Arch Linux only.

Check:

    cat /etc/os-release

## pacman Not Found

The bootstrap expects an existing Arch Linux installation.

## GitHub CLI Not Authenticated

Run:

    gh auth login

Then verify:

    gh auth status

## Docker Installed but Not Running

Check:

    systemctl status docker

On systems where Docker has been intentionally configured:

    sudo systemctl enable --now docker

## Hyprland Not Detected

Check:

    command -v Hyprland

The health check may warn when Hyprland is installed but not currently running.

## Wayland Not Detected

Check:

    echo $WAYLAND_DISPLAY

A warning is normal when running health checks outside a graphical Wayland session.

## Neovim Health

Start Neovim:

    nvim

For built-in diagnostics:

    :checkhealth

## Broken Symlinks

Run:

    find ~/.config -xtype l -print

## Restore Dotfiles

List snapshots:

    ./scripts/dotfiles.sh --backups

Then restore the required snapshot:

    ./scripts/dotfiles.sh --restore /path/to/snapshot

## Installation Planning

You can always preview without applying:

    ./scripts/install.sh --profile complete

Do not add --apply until the plan is correct.
