# Architecture

## Goal

This repository provisions and maintains my personal Arch Linux development workstation.

The project is designed around a simple principle:

- bootstrap.sh orchestrates
- install.sh installs dotfiles
- lib/ contains reusable modules

## Structure

```
bootstrap.sh
install.sh
lib/
tests/
docs/
```

## Libraries

- constants.sh
- logging.sh
- system.sh
- packages.sh
- shell.sh
- docker.sh
- directories.sh
- git.sh
- dotfiles.sh
- verify.sh

Each library owns a single responsibility.

## Validation

Run:

```bash
make check
```

before every commit.

## Philosophy

- Small commits
- Reproducible workstation
- Modular design
- Keep ML4W as the desktop foundation
- Keep personal configuration in ~/dotfiles
