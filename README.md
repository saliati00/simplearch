# Simple Arch

Simple Arch is a project focused on making Arch Linux installation easier by
providing a complete and usable desktop by default, without excess packages or
heavy tweaks: just a solid base.

The project includes Flatpak by default, plus snapshots configured with Btrfs,
Snapper and grub-btrfs to make system recovery easier if something breaks after
updates or local changes.

Simple Arch uses packages from the official Arch Linux repositories and, when
needed, from the AUR. The project does not aim to depend on third-party
repositories to assemble the system.

## Status

Simple Arch is in early development. The live ISO already uses KDE Plasma and
Calamares, and the first full installation flow has been validated in a virtual
machine. Wider hardware, snapshot and rollback testing is still pending.

## Documentation

- Project scope: [SCOPE.md](SCOPE.md)
- ISO profile: [archiso/](archiso/)
- Build scripts: [scripts/](scripts/)

## Disclaimer

Simple Arch is an independent open-source project and is not affiliated with,
endorsed, sponsored, or maintained by Arch Linux.
