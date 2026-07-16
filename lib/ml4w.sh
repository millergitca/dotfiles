#!/usr/bin/env bash

# ML4W-specific workstation preferences.
#
# This file expects lib/logging.sh to be sourced first.

configure_ml4w() {
  info "Configuring ML4W preferences"

  local ml4w_settings_dir="$HOME/.config/ml4w/settings"
  local terminal_file="$ml4w_settings_dir/terminal.sh"

  if [[ ! -d "$ml4w_settings_dir" ]]; then
    warn "ML4W settings directory not found; skipping ML4W configuration"
    return 0
  fi

  printf 'ghostty\n' > "$terminal_file"

  success "ML4W default terminal set to Ghostty"
}
