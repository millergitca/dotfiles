#!/usr/bin/env bash

# Post-bootstrap runtime verification.
#
# This file expects constants, logging, system, and T2 libraries
# to be sourced first.

verify_command() {
  local command_name="$1"

  if command_exists "$command_name"; then
    printf '  %-34s %s\n' "$command_name" "OK"
    return 0
  fi

  printf '  %-34s %s\n' "$command_name" "MISSING"
  return 1
}

verify_user_service() {
  local service_name="$1"

  if systemctl --user is-active --quiet "$service_name"; then
    printf '  %-34s %s\n' "$service_name" "ACTIVE"
    return 0
  fi

  printf '  %-34s %s\n' "$service_name" "INACTIVE"
  return 1
}

verify_system_service() {
  local service_name="$1"

  if systemctl is-active --quiet "$service_name"; then
    printf '  %-34s %s\n' "$service_name" "ACTIVE"
    return 0
  fi

  printf '  %-34s %s\n' "$service_name" "INACTIVE"
  return 1
}

verify_link_target() {
  local target="$1"
  local expected_source="$2"

  if [[ ! -L "$target" ]]; then
    printf '  %-34s %s\n' "$target" "NOT LINKED"
    return 1
  fi

  if [[ "$(readlink -f "$target")" == "$(readlink -f "$expected_source")" ]]; then
    printf '  %-34s %s\n' "$target" "OK"
    return 0
  fi

  printf '  %-34s %s\n' "$target" "WRONG TARGET"
  return 1
}

verify_file_value() {
  local file="$1"
  local expected_value="$2"
  local label="$3"
  local actual_value

  if [[ ! -f "$file" ]]; then
    printf '  %-34s %s\n' "$label" "MISSING"
    return 1
  fi

  actual_value="$(<"$file")"

  if [[ "$actual_value" == "$expected_value" ]]; then
    printf '  %-34s %s\n' "$label" "OK"
    return 0
  fi

  printf '  %-34s %s\n' "$label" "UNEXPECTED"
  printf '    expected: %s\n' "$expected_value"
  printf '    actual:   %s\n' "$actual_value"
  return 1
}

verify_setup() {
  info "Verifying workstation state"

  local failures=0
  local tool

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
    pactl
    wpctl
  )

  printf '\nCommands\n'

  for tool in "${tools[@]}"; do
    verify_command "$tool" || failures=1
  done

  printf '\nUser services\n'

  verify_user_service pipewire.service || failures=1
  verify_user_service pipewire-pulse.service || failures=1
  verify_user_service wireplumber.service || failures=1

  printf '\nSystem services\n'

  verify_system_service docker.service || failures=1

  printf '\nUser and group state\n'

  if id -nG "$USER" | tr ' ' '\n' | grep -qx docker; then
    printf '  %-34s %s\n' "docker group membership" "OK"
  else
    printf '  %-34s %s\n' "docker group membership" "MISSING"
    failures=1
  fi

  printf '\nDotfile links\n'

  verify_link_target \
    "$HOME/.config/ghostty/config" \
    "$DOTFILES_DIR/ghostty/.config/ghostty/config" ||
    failures=1

  verify_link_target \
    "$HOME/.config/zsh/developer-tools.zsh" \
    "$DOTFILES_DIR/zsh/.config/zsh/developer-tools.zsh" ||
    failures=1

  verify_link_target \
    "$HOME/.p10k.zsh" \
    "$DOTFILES_DIR/zsh/.p10k.zsh" ||
    failures=1

  verify_link_target \
    "$HOME/.config/nvim" \
    "$DOTFILES_DIR/nvim/.config/nvim" ||
    failures=1

  verify_link_target \
    "$HOME/.config/hypr/custom.lua" \
    "$DOTFILES_DIR/hypr/.config/hypr/custom.lua" ||
    failures=1

  verify_link_target \
    "$HOME/.config/waybar/themes/tokyo-night-storm" \
    "$DOTFILES_DIR/waybar/.config/waybar/themes/tokyo-night-storm" ||
    failures=1

  printf '\nML4W preferences\n'

  verify_file_value \
    "$HOME/.config/ml4w/settings/terminal.sh" \
    "$ML4W_DEFAULT_TERMINAL" \
    "ML4W terminal" ||
    failures=1

  verify_file_value \
    "$HOME/.config/ml4w/settings/waybar-theme.sh" \
    "$ML4W_DEFAULT_WAYBAR_THEME" \
    "ML4W Waybar theme" ||
    failures=1

  verify_file_value \
    "$HOME/.config/ml4w/settings/blur.sh" \
    "$ML4W_DEFAULT_BLUR" \
    "ML4W blur" ||
    failures=1

  printf '\nAudio\n'

  if pactl info >/dev/null 2>&1; then
    printf '  %-34s %s\n' "PulseAudio compatibility" "OK"
  else
    printf '  %-34s %s\n' "PulseAudio compatibility" "FAILED"
    failures=1
  fi

  if is_t2_macbook; then
    printf '\nApple T2 hardware\n'

    if lsmod | grep -q '^appletbdrm'; then
      printf '  %-34s %s\n' "appletbdrm module" "LOADED"
    else
      printf '  %-34s %s\n' "appletbdrm module" "MISSING"
      failures=1
    fi

    verify_system_service tiny-dfr.service || failures=1

    if [[ -e /sys/class/backlight/appletb_backlight/brightness ]]; then
      printf '  %-34s %s\n' "Touch Bar backlight device" "OK"
    else
      printf '  %-34s %s\n' "Touch Bar backlight device" "MISSING"
      failures=1
    fi

    if [[ -e /sys/class/leds/:white:kbd_backlight/brightness ]]; then
      printf '  %-34s %s\n' "keyboard backlight device" "OK"
    else
      printf '  %-34s %s\n' "keyboard backlight device" "MISSING"
      failures=1
    fi

    if [[ -x /usr/lib/systemd/system-sleep/t2-touchbar ]]; then
      printf '  %-34s %s\n' "T2 resume hook" "OK"
    else
      printf '  %-34s %s\n' "T2 resume hook" "MISSING"
      failures=1
    fi
  fi

  printf '\n'

  if ((failures)); then
    warn "Workstation verification completed with failures."
    warn "Review the results above and log:"
    warn "$BOOTSTRAP_LOG_FILE"
  else
    success "Workstation verification passed"
  fi
}
