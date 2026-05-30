# Scripts

This directory contains helper scripts used by the ISO build and by Calamares.

Initial scope:

- post-installation configuration in chroot
- Snapper, grub-btrfs and Btrfs Assistant configuration
- optional AUR helper policy and integration
- Zsh configuration
- video driver adjustments

Local build:

```bash
./scripts/build-iso.sh
```

By default, the build uses `~/simplearch-build/work` and
`~/simplearch-build/out`. To override this:

```bash
BUILD_ROOT=/path/to/build ./scripts/build-iso.sh
```

Build the local Calamares package:

```bash
./scripts/build-calamares-package.sh
```

Create the local pacman repository for packages generated under `packages/`:

```bash
./scripts/build-local-repo.sh
```

`build-iso.sh` calls this script automatically if the local repository does not
exist yet.

Create the offline optional package repository used by the GPU selector:

```bash
./scripts/build-optional-repo.sh
```

`build-iso.sh` also calls this script automatically and copies the result to
`airootfs/opt/simplearch/offline-repo` in the temporary ISO profile.
