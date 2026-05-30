# Archiso Profile

This directory contains the Simple Arch `archiso` profile, based on the Arch
Linux `releng` profile.

Initial files:

- `profiledef.sh`
- `packages.x86_64`
- `pacman.conf`
- `airootfs/`
- live environment assets and configuration

Planned local build:

```bash
sudo mkarchiso -v -w ~/simplearch-build/work -o ~/simplearch-build/out archiso
```

Note: this first version was created before installing the `archiso` package
locally. Once the package is available, the profile should be compared against
`/usr/share/archiso/configs/releng` and adjusted if necessary.
