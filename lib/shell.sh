#!/usr/bin/env bash

# Login shell configuration for the development workstation.
#
# This file expects lib/logging.sh to be sourced first.

configure_shell() {
  info "Configuring Zsh"

  local zsh_path
  local ml4w_customization
  local ml4w_disabled_dir
  local ml4w_backup

  zsh_path="$(command -v zsh)"

  ml4w_customization="$HOME/.config/zshrc/20-customization"
  ml4w_disabled_dir="$HOME/.config/zshrc-disabled"
  ml4w_backup="$ml4w_disabled_dir/20-customization.ml4w-disabled"

  if [[ -f "$ml4w_customization" ]]; then
    info "Disabling conflicting ML4W Zsh customization"
    mkdir -p "$ml4w_disabled_dir"
    mv "$ml4w_customization" "$ml4w_backup"
    success "ML4W Zsh customization disabled"
  fi

  if [[ "$SHELL" != "$zsh_path" ]]; then
    chsh -s "$zsh_path"
    warn "Your login shell was changed to Zsh."
    warn "Log out and back in after bootstrap completes."
  else
    success "Zsh is already the login shell"
  fi
}
