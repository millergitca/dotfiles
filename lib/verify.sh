#!/usr/bin/env bash

# Post-bootstrap verification for expected workstation tools.
#
# This file expects constants, logging, and system libraries to be sourced.

verify_setup() {
  info "Verifying installed tools"

  local tools=(
    git
    gh
    ghostty
    zsh
    nvim
    tmux
    python
    node
    npm
    java
    go
    rustc
    cargo
    docker
    brightnessctl
  )

  local missing=0
  local tool

  for tool in "${tools[@]}"; do
    if command_exists "$tool"; then
      printf '  %-18s %s\n' "$tool" "OK"
    else
      printf '  %-18s %s\n' "$tool" "MISSING"
      missing=1
    fi
  done

  if ((missing)); then
    warn "Some expected tools are missing. Review the log:"
    warn "$BOOTSTRAP_LOG_FILE"
  else
    success "All expected tools were found"
  fi
}
