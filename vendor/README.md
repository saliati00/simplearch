# Vendor

This directory stores external sources used temporarily during development.

Current contents:

- `calamares-3.4.2.tar.gz`: upstream Calamares source used to build a local
  Arch package, because `calamares` is not available in the official Arch
  repositories in this environment.

In the future, this should ideally be replaced by a reproducible flow with a
custom package, a custom package repository, or a documented CI build step.
