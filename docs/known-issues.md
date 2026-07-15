# Known Issues

This document tracks temporary workarounds and upstream issues that affect this workstation.

---

## Waybar clock one hour behind

### Status

Active workaround

### Affected

- Waybar 0.15.x
- tzdata 2026c (or affected future versions)

### Symptoms

The built-in Waybar `clock` module displays the correct timezone but remains exactly one hour behind the system clock.

The following commands all report the correct time:

```bash
date
timedatectl
```

Only the Waybar clock is incorrect.

### Workaround

Use a `custom/clock` module that executes:

```bash
date '+%H:%M %a'
```

instead of the built-in Waybar `clock` module.

### Remove when

Replace the workaround once the upstream Waybar/timezone issue has been resolved.
