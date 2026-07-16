#!/usr/bin/env bash

# ML4W-specific workstation preferences.
#
# This file expects lib/logging.sh to be sourced first.

ML4W_DEFAULT_TERMINAL="ghostty"
ML4W_DEFAULT_WAYBAR_THEME="/tokyo-night-storm;/tokyo-night-storm"

configure_ml4w() {
  info "Configuring ML4W preferences"

  local ml4w_settings_dir="$HOME/.config/ml4w/settings"
  local terminal_file="$ml4w_settings_dir/terminal.sh"
  local waybar_theme_file="$ml4w_settings_dir/waybar-theme.sh"

  if [[ ! -d "$ml4w_settings_dir" ]]; then
    warn "ML4W settings directory not found; skipping ML4W configuration"
    return 0
  fi

  printf '%s\n' "$ML4W_DEFAULT_TERMINAL" > "$terminal_file"
  printf '%s\n' "$ML4W_DEFAULT_WAYBAR_THEME" > "$waybar_theme_file"

  success "ML4W default terminal set to $ML4W_DEFAULT_TERMINAL"
  success "ML4W Waybar theme set to Tokyo Night Storm"
}
