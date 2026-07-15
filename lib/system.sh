#!/usr/bin/env bash

# Shared system and command-detection helpers.
#
# This file is intended to be sourced after lib/logging.sh because
# require_command uses the fail helper.

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

require_command() {
  local command_name="$1"

  command_exists "$command_name" ||
    fail "Required command was not found: $command_name"
}

is_arch_linux() {
  [[ -f /etc/arch-release ]]
}

is_root() {
  [[ "$EUID" -eq 0 ]]
}

configure_networking () {
  info "Configuring NetworkManager with the iwd Wi-Fi backend"

  sudo install -d -m 755 /etc/NetworkManager/conf.d

  printf '%s\n' \
    '[device]' \
    'wifi.backend=iwd' |
    sudo tee /etc/NetworkManager/conf.d/wifi_backend.conf >/dev/null

  sudo systemctl enable iwd.service
  sudo systemctl enable NetworkManager.service

  success "NetworkManager iwd backend configured"
}
