# Calamares

This directory contains Calamares installer configuration.

Important note: `calamares` is not available in the official Arch repositories
in this environment. The upstream source was placed at
`vendor/calamares-3.4.2.tar.gz`, and an initial `PKGBUILD` lives in
`packages/calamares/`.

To build the local package:

```bash
./scripts/build-calamares-package.sh
```

After that, a local pacman repository must still be created so `archiso` can
consume it during the build.

Initial scope:

- `settings.conf`
- partitioning, locale, user, bootloader and package modules
- simple video driver selection
- `shellprocess` calls for final chroot adjustments

Current status:

- The ISO includes a minimal configuration under
  `archiso/airootfs/etc/calamares`.
- This configuration validates that Calamares opens and that the basic
  interface modules work.
- It should not be treated as a final installation flow until partitioning,
  unpackfs, bootloader, users and post-installation steps are fully validated.

Locale and timezone:

- Calamares supports GeoIP in the `locale` module to detect timezone.
- The `welcome` module can also use GeoIP to preselect language based on the
  user's country.
- The initial configuration should use an HTTPS GeoIP service, preferably the
  KDE-maintained endpoint used in upstream examples:
  `https://geoip.kde.org/v1/calamares`.
- The installer must still allow manual language, keyboard and timezone changes;
  GeoIP is a convenience, not a requirement.
