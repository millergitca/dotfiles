# MNCM Labs Changelog

## 0.7.0

### Added

- modular installer profiles
- package groups
- safe dotfile backup and deployment
- restore support
- system health checks
- post-install verification
- installation documentation
- troubleshooting documentation
- architecture documentation
- release readiness checks

### Status

Pre-1.0 development release.

The public installer is intentionally conservative and does not use a remote curl-to-shell workflow.

## 0.7.1

### Added

- macOS development-host detection
- development-host health status
- skipped Arch-only health checks on macOS
- --plan-anywhere installer option
- cross-platform installation-plan generation

### Safety

Apply Mode remains restricted to Arch Linux.

macOS and other development hosts can inspect and plan but cannot use the installer to install Arch packages.

## 0.8.0-rc1

### Release Candidate

This release introduces automated Arch Linux userspace testing.

### Added

- Arch Linux container CI
- native Arch operating-system detection test
- pacman availability validation
- minimal profile planning test
- developer profile planning test
- complete profile planning test
- plan-mode package-state safety test
- Arch health-check execution
- automated release-readiness validation

### Development Status

This is a release candidate.

Automated tests now cover both:

- general Linux CI validation
- Arch Linux container validation

Real-machine testing is still required before v1.0.0.

The container test does not prove:

- graphical Hyprland startup
- Wayland session behavior
- GPU behavior
- display configuration
- laptop hardware integration
- suspend/resume
- actual full Apply Mode installation

Those remain real-system tests.
