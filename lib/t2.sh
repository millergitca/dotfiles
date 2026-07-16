#!/usr/bin/env bash

# Apple T2 MacBook hardware configuration.
#
# This file expects lib/logging.sh to be sourced first.

T2_DEFAULT_KEYBOARD_BRIGHTNESS="35%"

is_t2_macbook() {
  [[ -d /sys/bus/pci/drivers/apple-bce ]] ||
    grep -qi 'Apple T2' /proc/cpuinfo 2>/dev/null
}

configure_t2() {
  if ! is_t2_macbook; then
    info "Apple T2 hardware not detected; skipping T2 configuration"
    return 0
  fi

  info "Configuring Apple T2 hardware"

  local modules_source="$DOTFILES_DIR/system/modules-load/appletbdrm.conf"
  local override_source="$DOTFILES_DIR/system/systemd/tiny-dfr.service.d/override.conf"
  local sleep_hook_source="$DOTFILES_DIR/system/system-sleep/t2-touchbar"

  sudo install -D -m 644 \
    "$modules_source" \
    /etc/modules-load.d/appletbdrm.conf

  sudo install -D -m 644 \
    "$override_source" \
    /etc/systemd/system/tiny-dfr.service.d/override.conf

  sudo install -D -m 755 \
    "$sleep_hook_source" \
    /usr/lib/systemd/system-sleep/t2-touchbar

  sudo systemctl daemon-reload
  sudo systemctl enable tiny-dfr.service

  if [[ -e /sys/class/leds/:white:kbd_backlight/brightness ]]; then
    brightnessctl -q \
      -d ':white:kbd_backlight' \
      set "$T2_DEFAULT_KEYBOARD_BRIGHTNESS" || true
  fi

  success "Apple T2 modules and resume handling configured"
}
