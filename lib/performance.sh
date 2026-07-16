#!/usr/bin/env bash

# Workstation performance configuration.
#
# This file expects logging, system, and T2 libraries to be sourced first.

configure_performance() {
  info "Configuring workstation performance"

  local performance_script_source
  local performance_service_source
  local fan_config_source

  performance_script_source="$DOTFILES_DIR/system/scripts/set-cpu-performance"
  performance_service_source="$DOTFILES_DIR/system/systemd/cpu-performance.service"
  fan_config_source="$DOTFILES_DIR/system/performance/t2fand.conf"

  sudo install -D -m 755 \
    "$performance_script_source" \
    /usr/local/libexec/miller-set-cpu-performance

  sudo install -D -m 644 \
    "$performance_service_source" \
    /etc/systemd/system/cpu-performance.service

  sudo systemctl daemon-reload
  sudo systemctl enable --now cpu-performance.service

  success "CPU energy preference set to performance"

  if is_t2_macbook; then
    if [[ -f "$fan_config_source" ]] &&
       systemctl list-unit-files t2fanrd.service \
         --no-legend 2>/dev/null |
         grep -q '^t2fanrd\.service'; then
      sudo install -m 644 \
        "$fan_config_source" \
        /etc/t2fand.conf

      sudo systemctl enable --now t2fanrd.service
      sudo systemctl restart t2fanrd.service

      success "T2 performance fan curve applied"
    else
      warn "T2 fan configuration could not be applied"
    fi
  fi
}
