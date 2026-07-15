#!/usr/bin/env bash

# Docker service and user access configuration.
#
# This file expects lib/logging.sh to be sourced first.

configure_docker() {
  info "Configuring Docker"

  sudo systemctl enable --now docker.service

  if ! id -nG "$USER" | tr ' ' '\n' | grep -qx docker; then
    sudo usermod -aG docker "$USER"
    warn "You were added to the docker group."
    warn "Log out and back in before using Docker without sudo."
  else
    success "User is already in the docker group"
  fi
}
