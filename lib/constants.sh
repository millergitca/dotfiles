#!/usr/bin/env bash

# Shared project paths and state.
#
# bootstrap.sh must export DOTFILES_DIR before sourcing this file.

: "${DOTFILES_DIR:?DOTFILES_DIR must be be set before sourcing lib/constants.sh}"

export DOTFILES_LIB_DIR="$DOTFILES_DIR/lib"

export DOTFILES_STATE_DIR="$HOME/.local/state/dotfiles"
export DOTFILES_LOG_DIR="$DOTFILES_STATE_DIR/logs"

mkdir -p "$DOTFILES_LOG_DIR"

BOOTSTRAP_LOG_FILE="$DOTFILES_LOG_DIR/bootstrap-$(date +%Y%m%d-%H%M%S).log"
export BOOTSTRAP_LOG_FILE
