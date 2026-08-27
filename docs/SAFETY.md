# MNCM Labs Safety

The bootstrap defaults to audit mode.

Running:

    ./scripts/bootstrap.sh

does not intentionally install packages or deploy configuration.

Apply mode requires:

    ./scripts/bootstrap.sh --apply

The bootstrap currently does not:

- overwrite dotfiles
- delete user configuration
- repartition disks
- modify filesystems
- modify the bootloader
- automatically install AUR packages

Safe configuration backups will be added before dotfile deployment is enabled.
