# Local Packages

This directory stores packaging recipes for components that are not available in
the official Arch repositories but are required by the ISO.

Current packages:

- `calamares`: built from `vendor/calamares-3.4.2.tar.gz`.

Planned flow:

1. Build the package with `makepkg`.
2. Create a local pacman repository with `repo-add`.
3. Make `archiso` consume that local repository during the build.
