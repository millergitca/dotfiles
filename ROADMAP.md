# Miller Development Workstation Roadmap

> ## Mission
>
> Build a reproducible, version-controlled Arch Linux development workstation
> that can be recreated on supported hardware from a clean installation using a
> single bootstrap command.
>
> Every release should reduce manual configuration, improve reliability, and
> move the project closer to a fully automated workstation that looks,
> behaves, and performs identically across all supported machines.

---

# Current Focus

🎯 **v1.2.0 — Complete Workstation Recreation**

The current objective is to make a fresh Arch Linux + ML4W installation
indistinguishable from my daily development environment after running
`bootstrap.sh`.

The MacBook Pro 13" serves as the integration test machine.

The MacBook Pro 16" serves as the production workstation.

---

# Development Workflow

Every feature follows the same workflow:

```
Development (13")

        │
        ▼

Implement Feature

        │
        ▼

Bootstrap Test

        │
        ▼

Manual Verification

        │
        ▼

Commit & Push

        │
        ▼

Update Documentation

        │
        ▼

GitHub Release

        │
        ▼

Deploy to Production (16")
```

Nothing is considered complete until it has been successfully tested on the
integration machine.

---

# Philosophy

This repository is more than a collection of dotfiles.

It is an engineering project focused on building a complete,
reproducible development workstation through automation.

Every improvement should be:

- Reproducible
- Modular
- Version Controlled
- Hardware Aware
- Well Documented
- Fully Tested

Whenever possible:

- automate instead of documenting manual steps
- fix root causes instead of symptoms
- keep hardware-specific logic isolated
- keep configuration modular
- validate changes before releasing

---

# Current Environment

## Production

- MacBook Pro 16,1 (2019)
- Apple T2
- Daily Driver

## Integration

- MacBook Pro 13" (Apple T2)
- Bootstrap Validation
- Clean Install Testing
- Release Verification

---

# Software Stack

## Operating System

- Arch Linux
- Hyprland (ML4W)
- Wayland

## Development

- Ghostty
- Zsh
- Powerlevel10k
- Neovim
- VS Code
- Docker
- Git
- GitHub CLI

---

# Release History

## ✅ v1.0.0

Clean Workstation Base

Completed

- Initial workstation bootstrap
- Base package installation
- Dotfile management
- Core development environment

---

## ✅ v1.1.0

Architecture Refactor

Completed

- Modular bootstrap architecture
- Shared libraries
- Repository cleanup
- Testing framework
- Documentation improvements

---

# 🚧 v1.2.0

## Complete Workstation Recreation

### Bootstrap

- [x] Bootstrap validated on second machine
- [x] Tree-sitter CLI automation
- [x] ShellCheck integration
- [x] Powerlevel10k automation
- [x] Ghostty automation
- [x] ML4W module
- [x] ML4W terminal automation
- [x] ML4W Waybar automation

### ML4W

- [ ] Restore complete ML4W Settings
- [ ] Fonts
- [ ] Blur
- [ ] Decorations
- [ ] Wallpaper
- [ ] GTK Theme
- [ ] QT Theme
- [ ] Cursor Theme
- [ ] Lock Screen
- [ ] Notifications
- [ ] Default Applications

### Desktop

- [ ] Desktop parity (13" ↔ 16")
- [ ] Waybar parity
- [ ] Ghostty launcher integration
- [ ] Wallpaper automation
- [ ] Appearance verification

### Hardware

- [ ] Keyboard backlight
- [ ] Touch Bar polish
- [ ] Wi-Fi improvements
- [ ] Suspend / Resume validation
- [ ] Brightness controls

### Input

- [ ] Trackpad configuration
- [ ] Copy / Paste
- [ ] Tap-to-click
- [ ] Right-click
- [ ] Three-finger gestures
- [ ] Natural scrolling

### Validation

- [ ] Fresh bootstrap on 13"
- [ ] Fresh bootstrap on 16"
- [ ] Zero manual configuration
- [ ] Release candidate verification

---

# Planned Releases

## v1.3.0

Developer Environment

### Neovim

- [ ] LSP improvements
- [ ] Debugging
- [ ] Testing
- [ ] Formatting
- [ ] Performance tuning

### VS Code

- [ ] Extensions
- [ ] Settings Sync
- [ ] Dev Containers
- [ ] Theme automation

### Terminal

- [ ] Productivity aliases
- [ ] Git helpers
- [ ] Docker helpers
- [ ] Utility scripts

---

## v1.4.0

Computer Science Toolkit

Languages

- [ ] C
- [ ] C++
- [ ] Python
- [ ] Java
- [ ] Go
- [ ] Rust

Developer Tools

- [ ] CMake
- [ ] Make
- [ ] GDB
- [ ] LLDB
- [ ] Valgrind
- [ ] Profiling tools

---

## v1.5.0

Content Creation

Streaming

- [ ] OBS
- [ ] Scene Collection
- [ ] Audio Routing
- [ ] Camera Profiles

Editing

- [ ] FFmpeg
- [ ] Thumbnail Templates
- [ ] Video Automation

Publishing

- [ ] Twitch Workflow
- [ ] YouTube Workflow

---

# Future

- [ ] Multi-machine profiles
- [ ] Automatic hardware detection
- [ ] Apple T2 support module
- [ ] CI validation
- [ ] GitHub Actions
- [ ] Secrets management
- [ ] Backup automation
- [ ] One-command workstation provisioning

---

# Success Criteria

The project reaches its primary objective when the following workflow works
without any manual configuration:

```bash
git clone https://github.com/millergitca/dotfiles.git

cd dotfiles

./bootstrap.sh
```

After logging out and back in, the workstation should:

- match the configured desktop appearance
- restore the complete development environment
- configure supported hardware automatically
- require no manual post-installation steps
- be ready for software development immediately
