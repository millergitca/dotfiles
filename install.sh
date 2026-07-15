#!/usr/bin/env bash
set -Eeuo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$HOME/.config-backups/dotfiles-install-$STAMP"

mkdir -p "$BACKUP"

link_file() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"

  if [[ -e "$target" || -L "$target" ]]; then
    if [[ "$(readlink -f "$target" 2>/dev/null || true)" == "$(readlink -f "$source")" ]]; then
      echo "Already linked: $target"
      return
    fi

    mv "$target" "$BACKUP/$(echo "$target" | sed "s|$HOME/||; s|/|__|g")"
  fi

  ln -s "$source" "$target"
  echo "Linked: $target"
}

link_file \
  "$DOTFILES/ghostty/.config/ghostty/config" \
  "$HOME/.config/ghostty/config"

if [[ -f "$DOTFILES/zsh/.config/zsh/developer-tools.zsh" ]]; then
  link_file \
    "$DOTFILES/zsh/.config/zsh/developer-tools.zsh" \
    "$HOME/.config/zsh/developer-tools.zsh"
fi

if [[ -d "$DOTFILES/nvim/.config/nvim" ]]; then
  link_file \
    "$DOTFILES/nvim/.config/nvim" \
    "$HOME/.config/nvim"
fi

if [[ -f "$DOTFILES/vscode/.config/Code/User/settings.json" ]]; then
  link_file \
    "$DOTFILES/vscode/.config/Code/User/settings.json" \
    "$HOME/.config/Code/User/settings.json"
fi

if [[ -f "$DOTFILES/vscode/.config/Code/User/keybindings.json" ]]; then
  link_file \
    "$DOTFILES/vscode/.config/Code/User/keybindings.json" \
    "$HOME/.config/Code/User/keybindings.json"
fi

if [[ -f "$DOTFILES/hypr/.config/hypr/custom.lua" ]]; then
  link_file \
    "$DOTFILES/hypr/.config/hypr/custom.lua" \
    "$HOME/.config/hypr/custom.lua"
fi

if [[ -d "$DOTFILES/waybar/.config/waybar/themes/tokyo-night-storm" ]]; then
  link_file \
    "$DOTFILES/waybar/.config/waybar/themes/tokyo-night-storm" \
    "$HOME/.config/waybar/themes/tokyo-night-storm"
fi

if ! grep -Fq '.config/zsh/developer-tools.zsh' "$HOME/.zshrc"; then
  cp -a "$HOME/.zshrc" "$BACKUP/zshrc" 2>/dev/null || true

  # shellcheck disable=SC2016
  printf '\n%s\n' \
    '[[ -r "$HOME/.config/zsh/developer-tools.zsh" ]] && source "$HOME/.config/zsh/developer-tools.zsh"' \
    >> "$HOME/.zshrc"
fi

echo
echo "Dotfiles installed."
echo "Backups: $BACKUP"
