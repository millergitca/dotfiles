# MNCM Labs Testing

MNCM Labs uses multiple testing layers.

## Repository Validation

The primary repository test is:

    ./tests/check.sh

It validates:

- required files
- Bash syntax
- executable permissions
- package definitions
- version format
- ShellCheck diagnostics
- Git whitespace

## macOS Development Host

macOS can run:

    ./scripts/health.sh

and:

    ./scripts/install.sh --profile complete --plan-anywhere

Apply Mode remains blocked.

## Arch Linux Container

GitHub Actions runs the project inside the official Arch Linux container image.

The Arch test validates:

- Arch detection
- pacman availability
- script parsing
- installer CLI
- dotfile CLI
- health-check execution
- minimal profile planning
- developer profile planning
- complete profile planning
- package-state preservation during Plan Mode
- release readiness

## What Container Testing Cannot Prove

A container cannot fully test a graphical Arch workstation.

The following require a real Arch installation:

- Hyprland startup
- Wayland session behavior
- GPU drivers
- monitors
- audio hardware
- laptop-specific hardware
- suspend and resume
- full desktop dotfile behavior
- complete Apply Mode installation

## Release Policy

A green CI pipeline is required for a release candidate.

A stable v1.0.0 should additionally pass real Arch Linux installation testing.
