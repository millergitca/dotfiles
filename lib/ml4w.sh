#!/usr/bin/env bash

# ML4W-specific workstation preferences.
#
# This file expects lib/logging.sh to be sourced first.

ML4W_DEFAULT_TERMINAL="ghostty"
ML4W_DEFAULT_WAYBAR_THEME="/tokyo-night-storm;/tokyo-night-storm"
ML4W_DEFAULT_BLUR="80x80"
ML4W_DEFAULT_ROFI_FONT="JetBrainsMono Nerd Font 13"
ML4W_DEFAULT_WAYBAR_QUICKLINKS="True"
ML4W_DEFAULT_WAYBAR_TASKBAR="True"

configure_ml4w() {
  info "Configuring ML4W preferences"

  local ml4w_settings_dir="$HOME/.config/ml4w/settings"
  local terminal_file="$ml4w_settings_dir/terminal.sh"
  local waybar_theme_file="$ml4w_settings_dir/waybar-theme.sh"
  local blur_file="$ml4w_settings_dir/blur.sh"
  local rofi_font_file="$ml4w_settings_dir/rofi-font.rasi"
  local waybar_quicklinks_file="$ml4w_settings_dir/waybar_quicklinks.sh"
  local waybar_taskbar_file="$ml4w_settings_dir/waybar_taskbar.sh"

  if [[ ! -d "$ml4w_settings_dir" ]]; then
    warn "ML4W settings directory not found; skipping ML4W configuration"
    return 0
  fi

  printf '%s\n' "$ML4W_DEFAULT_TERMINAL" > "$terminal_file"
  printf '%s\n' "$ML4W_DEFAULT_WAYBAR_THEME" > "$waybar_theme_file"
  printf '%s\n' "$ML4W_DEFAULT_BLUR" > "$blur_file"

  printf 'configuration { font: "%s"; }\n' \
    "$ML4W_DEFAULT_ROFI_FONT" \
    > "$rofi_font_file"

  printf '%s\n' "$ML4W_DEFAULT_WAYBAR_QUICKLINKS" \
    > "$waybar_quicklinks_file"

  printf '%s\n' "$ML4W_DEFAULT_WAYBAR_TASKBAR" \
    > "$waybar_taskbar_file"

  success "ML4W default terminal set to $ML4W_DEFAULT_TERMINAL"
  success "ML4W Waybar theme set to Tokyo Night Storm"
  success "ML4W blur setting set to $ML4W_DEFAULT_BLUR"
  success "ML4W Rofi font set to $ML4W_DEFAULT_ROFI_FONT"
  success "ML4W Waybar quick links enabled"
  success "ML4W Waybar taskbar enabled"
}
