#!/usr/bin/env bash

# Development and university workspace directories.
#
# This file expects lib/logging.sh to be sourced first.

create_directories() {
  info "Creating development directories"

  mkdir -p \
    "$HOME/Projects/Personal" \
    "$HOME/Projects/University" \
    "$HOME/Projects/OpenSource" \
    "$HOME/Projects/Experiments" \
    "$HOME/University/Notes" \
    "$HOME/University/Assignments" \
    "$HOME/University/Resources" \
    "$HOME/University/Templates" \
    "$HOME/Scripts"

  success "Development directories created"
}
