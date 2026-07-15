#!/usr/bin/env bash

# Non-personal Git defaults for the development workstation.
#
# This file expects lib/logging.sh to be sourced first.

configure_git() {
  info "Applying non-personal Git defaults"

  git config --global init.defaultBranch main
  git config --global core.editor nvim
  git config --global core.autocrlf input
  git config --global fetch.prune true
  git config --global push.autoSetupRemote true
  git config --global rerere.enabled true

  if ! git config --global user.name >/dev/null; then
    warn "Git user.name is not configured."
    warn 'Set it later with: git config --global user.name "Your Name"'
  fi

  if ! git config --global user.email >/dev/null; then
    warn "Git user.email is not configured."
    warn 'Set it later with: git config --global user.email "you@example.com"'
  fi

  success "Git defaults configured"
}
