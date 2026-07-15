#!/usr/bin/env bash

# Installation of configuration files tracked by this repository.
#
# This file expects lib/constants.sh and lib/logging.sh to be sourced first.

install_dotfiles() {
  info "Installing tracked dotfiles"

  [[ -f "$DOTFILES_DIR/install.sh" ]] ||
    fail "install.sh was not found in $DOTFILES_DIR."

  chmod +x "$DOTFILES_DIR/install.sh"
  "$DOTFILES_DIR/install.sh"

  success "Dotfiles installed"
}
