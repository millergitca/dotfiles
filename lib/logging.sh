#!/usr/bin/env bash

# Shared terminal output helpers.
#
# This file is intended to be sourced by other dotfiles scripts.
# It must not enable shell options or execute commands on its own.

info() {
  printf '\n\033[1;34m[INFO]\033[0m %s\n' "$*"
}

success() {
  printf '\033[1;32m[SUCCESS]\033[0m %s\n' "$*"
}

warn() {
  printf '\033[1;33m[WARN]\033[0m %s\n' "$*"
}

fail() {
  printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2
  exit 1
}
