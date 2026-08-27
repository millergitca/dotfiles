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
