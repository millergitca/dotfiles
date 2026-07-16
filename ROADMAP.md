# Miller Development Workstation Roadmap

> ## Mission
>
> Build a reproducible, version-controlled Arch Linux development workstation
> that can be recreated on supported hardware from a clean installation using a
> single bootstrap command.
>
> Every release should reduce manual configuration, improve reliability,
> improve portability, and move the project closer to a fully automated
> workstation that looks, behaves, and performs identically across all
> supported machines.

---

# Current Focus

🎯 **v1.2.0 — Complete Workstation Recreation**

The current objective is to eliminate the remaining manual configuration
required after a fresh Arch Linux + ML4W installation.

The bootstrap should configure the workstation to production quality with
minimal user interaction while validating that every subsystem functions
correctly.

The MacBook Pro 13" serves as the integration and validation machine.

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

Static Validation

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

GitHub Actions Validation

        │
        ▼

Update Documentation

        │
        ▼

Git Tag & Release

        │
        ▼

Deploy to Production (16")
```

Nothing is considered complete until it has:

- Passed local validation
- Passed GitHub Actions
- Passed runtime verification
- Been tested on the integration machine
- Been deployed successfully to the production workstation
- Been tagged and released on GitHub

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
- Safe to Re-run
- Production Ready

Whenever possible:

- Automate instead of documenting manual steps
- Fix root causes instead of symptoms
- Isolate hardware-specific logic
- Keep configuration modular
- Verify changes automatically
- Prefer reusable components over one-off fixes
- Maintain idempotent bootstrap behavior

---

# Current Environment

## Production

- MacBook Pro 16,1 (2019)
- Intel Core i9
- Apple T2
- Arch Linux
- Hyprland (ML4W)
- Daily Driver

---

## Integration

- MacBook Pro 13,2 (2020)
- Intel Core i7
- Apple T2
- Arch Linux
- Hyprland (ML4W)
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

## Runtime

- PipeWire
- WirePlumber
- NetworkManager (iwd)
- Docker
- brightnessctl
- tiny-dfr
- t2fanrd

---

# Release History

## ✅ v1.0.0

### Clean Workstation Base

Released

- Initial workstation bootstrap
- Base package installation
- Core development environment
- Dotfile management
- Initial repository structure

---

## ✅ v1.1.0

### Bootstrap Architecture

Released

- Modular bootstrap architecture
- Shared libraries
- Runtime logging
- Repository cleanup
- Static validation framework
- ShellCheck integration
- Documentation improvements

---

# 🚧 v1.2.0

## Complete Workstation Recreation

### Desktop

- [x] Ghostty automation
- [x] Waybar theme automation
- [x] ML4W terminal automation
- [x] ML4W blur automation
- [x] ML4W animation profile automation
- [x] GTK theme parity
- [x] QT theme parity
- [x] Cursor theme parity
- [x] Default applications parity
- [x] Desktop parity
- [ ] Final appearance verification

---

### Apple T2

- [x] tiny-dfr automation
- [x] Resume hook
- [x] Touch Bar restoration
- [x] Touch Bar brightness bindings
- [x] Keyboard backlight restoration
- [x] Keyboard brightness bindings
- [x] CPU performance tuning
- [x] T2 fan tuning
- [ ] Extended suspend / resume stress testing

---

### Audio

- [x] PipeWire automation
- [x] PipeWire Pulse compatibility
- [x] WirePlumber automation
- [x] Runtime verification

---

### Bootstrap

- [x] Runtime verification
- [x] ShellCheck integration
- [x] GitHub Actions CI
- [x] Tree-sitter CLI automation
- [x] Docker automation
- [x] ML4W module
- [x] Apple T2 module
- [ ] Hardware detection
- [ ] Installation profiles

---

### Validation

- [x] Bootstrap validated on 13"
- [ ] Bootstrap validated on 16"
- [ ] Zero manual intervention
- [ ] Tag v1.2.0
- [ ] Publish GitHub Release

---

# Planned Releases

## v1.3.0

### Portable Bootstrap

**Goal**

Make the bootstrap portable across supported hardware without modifying code.

### Features

- [ ] Automatic hardware detection
- [ ] Laptop profiles
- [ ] Desktop profiles
- [ ] Virtual Machine profile
- [ ] Optional package groups
- [ ] User configuration file
- [ ] Release packaging

---

## v1.4.0

### Developer Experience

#### Neovim

- [ ] LSP improvements
- [ ] Mason automation
- [ ] Treesitter improvements
- [ ] Debugging
- [ ] Testing
- [ ] Formatting

#### VS Code

- [ ] Extension automation
- [ ] Profiles
- [ ] Dev Containers

#### Terminal

- [ ] Lazygit
- [ ] Lazydocker
- [ ] tmux automation
- [ ] Productivity aliases
- [ ] Utility scripts

---

## v1.5.0

### Computer Science Toolkit

#### Languages

- [ ] C
- [ ] C++
- [ ] Python
- [ ] Java
- [ ] Go
- [ ] Rust

#### Developer Tools

- [ ] CMake
- [ ] Make
- [ ] GDB
- [ ] LLDB
- [ ] Valgrind
- [ ] Profiling tools

---

## v1.6.0

### Content Creation

#### Streaming

- [ ] OBS Studio
- [ ] Scene Collection
- [ ] Audio Routing
- [ ] Camera Profiles

#### Editing

- [ ] FFmpeg automation
- [ ] Thumbnail templates
- [ ] Video workflow automation

#### Publishing

- [ ] Twitch workflow
- [ ] YouTube workflow

---

# Future

- [ ] Multi-user configuration
- [ ] Automatic hardware detection expansion
- [ ] Secret management
- [ ] Backup automation
- [ ] Automatic release generation
- [ ] Release artifacts
- [ ] Documentation website
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

- Match the configured desktop appearance
- Restore the complete development environment
- Configure supported hardware automatically
- Configure Apple T2 hardware when applicable
- Require no manual post-installation
- Pass `./tests/check.sh`
- Pass runtime verification
- Pass GitHub Actions validation
- Be immediately ready for software development
