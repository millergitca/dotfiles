# Portable bootstrap readiness — local audit

Public identity verified: millergitca/dotfiles, MNCM LABS / ARCH LINUX BOOTSTRAP,
README links mncm.ca/labs. Starting revision a785989c18c9e918c1a78e05db27f35b2c4b46cf.
No preexisting local checkout was changed. No personal files were imported.

Roadmap disagreement: root ROADMAP describes v1.2 released/v1.3 development, while
VERSION is 0.8.0-rc1, README includes older 0.7 and docs/ROADMAP has stale unchecked
backup/deployment work. These are historical assertions, not fresh validation. Do not
label a release stable from them. Maintainer must reconcile version/tag history before
release; no versions/tags were changed. Installer now reads repository VERSION.

Implemented existing foundation: modular package groups, complete/developer/minimal/
custom plans; explicit apply confirmation and OS/root guards; config deployment and
backup/restore CLI; health/verify/release checks; Arch container CI. Existing personal
hardware/config references already in public history were not extended or copied from
this machine. Review public content separately before promising generic portability.

Local improvements: default plan forbids combining --plan-anywhere and --apply; package
names cannot act as flags and a final line without newline is retained. Generic chassis/
virtualization classification reports an advisory laptop/desktop/VM/unknown hint only;
it does not silently choose packages or tune hardware. Unknown hardware stays unknown.
Bash validation no longer depends on mapfile, absent in macOS system Bash 3.2.
Curated config export is a separate opt-in, synthetic-tested framework.

Remaining v1.3 decisions: explicit user config format/schema, stable release packaging,
selected laptop/desktop/VM package differences, T2 module conditions and supported
hardware matrix. Do not turn an advisory chassis hint into automatic apply behavior.
Gaming/creator/OBS profiles require reviewed package definitions and real Arch tests;
no current profile was silently expanded. Neovim/editor automation, scene collections,
voice/audio configuration and system service changes remain future work.

macOS evidence: repository checks, pure host fixtures, non-root plans for three profiles,
invalid-option/EOF package fixtures, export privacy tests, Bash syntax and release-check
pass. ShellCheck is not installed locally and remains a CI requirement. Docker is absent;
Arch container CI was not dispatched and no native Arch apply/restore/hardware test ran.
Real Arch verification still required: root/non-Arch protection, fresh install, repeated
apply, backup/restore, interruption recovery, package resolution, desktop/audio/T2 behavior,
VM/laptop/desktop matrix and no private data in exports. Never treat macOS planning as
Arch runtime proof. No public push, tag, release or workstation configuration change.
