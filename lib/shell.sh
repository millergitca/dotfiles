#!/usr/bin/env bash

# Login shell configuration for the development workstation.
#
# This file expects lib/logging.sh to be sourced first.

configure_shell() {
  info "Configuring Zsh"

  local zsh_path
  zsh_path="$(command -v zsh)"

  if [[ "$SHELL" != "$zsh_path" ]]; then
    chsh -s "$zsh_path"
    warn "Your login shell was changed to Zsh."
    warn "Log out and back in after bootstrap completes."
  else
    success "Zsh is already the login shell"
  fi
}
