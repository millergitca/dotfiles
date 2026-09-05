# Privacy-safe curated export

This framework does not discover, mirror, or read a home directory. No actual personal
configuration was exported while developing it. Tests use temporary synthetic files.
Never run a home-directory backup-to-Git process.

Flow: manually select and sanitize files → separate curated directory → explicit exact
allowlist → dry-run scanners → new staging directory → inspect manifest and full diff →
human-approved Git changes. There is no automatic git add, commit, push or upload.
The source requires a .mncm-curated-export.json marker containing exactly
`{"kind":"curated-export","version":1}`. This marker is an acknowledgment of manual
curation, not evidence that arbitrary content is safe. Keep source and output outside Git.

Use `python3 scripts/export-curated-config.py --source /path/to/curated --file ghostty/config`
for dry-run. Only an explicit --output to a new canonical staging directory writes files.
Run this yourself only after reviewing the source. Output manifest records relative names,
byte sizes and SHA-256, not personal absolute paths. Review the entire diff before commit.

Initial allowlist: hypr/hyprland.conf, waybar/config.jsonc, waybar/style.css, ghostty/config,
nvim/init.lua, zsh/config.zsh and packages/selected.txt. Theme/assets expansion requires
separate review. No globs, recursive home walks, symlinks or arbitrary binary files.
Missing inputs, duplicate selections, oversized/non-UTF8 text, private paths, suspicious
assignments/tokens, personal email, local IP and machine-specific fields fail closed.
All selected content is checked before staging creation; existing output is never replaced.

Hard exclusions include .ssh, .gnupg, environment files, credentials, browser profiles,
keychains, Documents, Photos, Downloads, private repositories, backups and app databases.
These scanners are a safety net, not a proof: generic configuration can embed secrets
in arbitrary text. Manual content review is mandatory; do not waive a scan merely because
an existing public repository already contains a machine-specific value.

The framework intentionally does not import directly from ~/.config. It has no scheduled
sync, background watcher or unattended personal export. Restore/import of reviewed repo
config remains the existing explicit dotfile deployment workflow, requiring backup and
real Arch testing. This exporter is not a backup/restore system.
