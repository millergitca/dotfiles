#!/usr/bin/env bash
set -Eeuo pipefail

DOTFILES="$HOME/dotfiles"
REPORT_DIR="$HOME/.local/state/dotfiles-migration"
STAMP="$(date +%Y%m%d-%H%M%S)"
REPORT="$REPORT_DIR/broken-links-$STAMP.tsv"

mkdir -p "$REPORT_DIR"
printf 'ACTION\tLINK\tOLD_TARGET\tPROPOSED_TARGET\tNOTES\n' > "$REPORT"

classify_link() {
    local link="$1"
    local raw_target resolved_old proposed="" action="MANUAL"
    local notes="Review manually"
    local relative=""

    raw_target="$(readlink "$link")"

    if [[ "$raw_target" == /* ]]; then
        resolved_old="$raw_target"
    else
        resolved_old="$(realpath -m "$(dirname "$link")/$raw_target")"
    fi

    # Sensitive locations: never alter automatically.
    case "$link" in
        "$HOME/.gnupg/"*|"$HOME/.local/share/keyrings/"*|"$HOME/.local/share/pki/"*|"$HOME/.local/share/flatpak/"*|"$HOME/.local/state/syncthing"*)
            action="SECURITY_REVIEW"
            notes="Sensitive data; review before modifying"
            ;;
    esac

    # Known mappings into the current dotfiles repository.
    case "$link" in
        "$HOME/.config/ghostty/config"|"$HOME/.config/ghostty/config.ghostty")
            proposed="$DOTFILES/ghostty/.config/ghostty/config"
            ;;
        "$HOME/.config/nvim")
            proposed="$DOTFILES/nvim/.config/nvim"
            ;;
        "$HOME/.config/hypr/custom.lua")
            proposed="$DOTFILES/hypr/.config/hypr/custom.lua"
            ;;
        "$HOME/.config/zsh/developer-tools.zsh")
            proposed="$DOTFILES/zsh/.config/zsh/developer-tools.zsh"
            ;;
    esac

    if [[ "$link" == "$HOME/.config/waybar/themes/tokyo-night-storm/"* ]]; then
        relative="${link#"$HOME/.config/waybar/themes/tokyo-night-storm/"}"
        proposed="$DOTFILES/waybar/.config/waybar/themes/tokyo-night-storm/$relative"
    fi

    if [[ -n "$proposed" && -e "$proposed" ]]; then
        action="RELINK_DOTFILES"
        notes="Replacement exists in ~/dotfiles"
    fi

    # Obsolete top-level links from the old configuration layout.
    case "$link" in
        "$HOME/.config/hyprland.lua"|"$HOME/.config/hyprland.conf"|"$HOME/.config/hyprlock.conf"|"$HOME/.config/.luarc.json"|"$HOME/.config/config.jsonc"|"$HOME/.config/config-minimal.jsonc"|"$HOME/.config/style.css"|"$HOME/.config/style-minimal.css"|"$HOME/.config/custom_modules"|"$HOME/.config/auto-reload.sh")
            action="REMOVE_LEGACY"
            proposed=""
            notes="Obsolete top-level link; current ML4W uses subdirectories"
            ;;
    esac

    # Disposable cache and retired application state.
    case "$link" in
        "$HOME/.cache/"*|"$HOME/.local/share/gnome-shell/"*|"$HOME/.local/share/epiphany/"*|"$HOME/.local/share/gvfs-metadata/"*|"$HOME/.local/share/applications/wine"*|"$HOME/.local/share/folks/"*|"$HOME/.local/share/evolution/"*|"$HOME/.local/share/recently-used.xbel"|"$HOME/.local/state/ly-session.log")
            action="REMOVE_DISPOSABLE"
            proposed=""
            notes="Cache or retired application state"
            ;;
    esac

    # Broken links that should become normal directories.
    case "$link" in
        "$HOME/.local/share/Trash"|"$HOME/.local/share/rofimoji"|"$HOME/.local/share/GitKrakenCLI"|"$HOME/.local/share/gk"|"$HOME/.local/share/pnpm"|"$HOME/.local/share/rofi"|"$HOME/.local/share/mime"|"$HOME/.local/share/nwg-look"|"$HOME/.local/share/desktop-directories")
            action="RECREATE_PATH"
            proposed=""
            notes="Replace broken link with a normal directory"
            ;;
    esac

    printf '%s\t%s\t%s\t%s\t%s\n' \
        "$action" "$link" "$resolved_old" "$proposed" "$notes" \
        >> "$REPORT"
}

while IFS= read -r link; do
    case "$link" in
        "$HOME/.config-backups/"*|"$HOME/yay/pkg/"*|"$HOME/dev-environment-files/"*)
            continue
            ;;
    esac

    classify_link "$link"
done < <(find "$HOME" -xdev -xtype l -print 2>/dev/null)

echo
echo "Migration audit complete."
echo "Report: $REPORT"
echo
echo "Summary:"

awk -F '\t' '
    NR > 1 { count[$1]++ }
    END {
        for (type in count) {
            printf "  %-20s %d\n", type, count[type]
        }
    }
' "$REPORT" | sort

echo
echo "Preview:"
column -s $'\t' -t "$REPORT" | sed -n '1,35p'

echo
echo "No files were changed."
