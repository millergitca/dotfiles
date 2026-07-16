#!/usr/bin/env bash

configure_audio() {
  info "Configuring PipeWire audio"

  systemctl --user daemon-reload

  systemctl --user enable --now pipewire.service
  systemctl --user enable --now pipewire-pulse.service
  systemctl --user enable --now wireplumber.service

  success "PipeWire audio configured"
}
