# Scope

This document defines the initial product and implementation decisions for
SimpleArch.

## Base

- Arch Linux base, using official repositories whenever possible.
- ISO built with `archiso`, derived from a modified `releng` profile.
- Live environment with KDE Plasma and the Calamares installer.
- Installed desktop based on `plasma-meta`.
- UEFI boot with GRUB; BIOS installation is outside the initial scope.
- Mandatory Btrfs filesystem to support snapshots and rollback.
- NetworkManager, PipeWire, Bluetooth, UFW, Flatpak, plasma-login-manager and
  zram with zstd by default.
- Live ISO defaults to English, with `pt_BR.UTF-8` available in the installer.
  Language, keyboard layout and timezone must follow the user's Calamares
  choices.
- `multilib` enabled.
- Firefox as the default browser.
- MPV as the default video player.
- Zsh with an Oh My Zsh-compatible default configuration for the user created
  during installation.
- Gaming packages are not part of the default installation.

## Storage

The installation should follow this layout whenever possible:

- 1 GiB EFI partition mounted at `/boot`.
- Btrfs partition for the rest of the system.
- `@` subvolume mounted at `/`.
- `@home` subvolume mounted at `/home`.
- `@snapshots` subvolume mounted at `/.snapshots`.
- `@log` subvolume mounted at `/var/log`.
- `@pkg` subvolume mounted at `/var/cache/pacman/pkg`.
- Btrfs compression using `compress=zstd`.

## Snapshots And Recovery

- Snapper configured for the root subvolume.
- Retention preconfigured to keep snapshots for up to 3 days.
- `ALLOW_USERS="wheel"` to allow administration by the created user.
- `snap-pac` for automatic snapshots when using pacman.
- `grub-btrfs` to expose snapshots in the GRUB menu.
- `btrfs-assistant` as the graphical interface.
- Required timers and services enabled automatically.
- GRUB regenerated after configuration.

## Video Driver

Calamares should expose a simple choice:

- Mesa, for Intel/AMD and general use.
- Nvidia proprietary, for older Nvidia GPUs when needed.
- Nvidia open DKMS, for newer Nvidia GPUs.

Expected packages for each option:

- Mesa: standard Arch Mesa stack.
- Nvidia proprietary: `dkms`, `linux-headers`, `nvidia-dkms` and
  `nvidia-utils`.
- Nvidia open DKMS: `dkms`, `linux-headers`, `nvidia-open-dkms` and
  `nvidia-utils`.

Optional Nvidia packages should be embedded in an offline pacman repository
inside the live ISO without being installed in the base system. Calamares should
mount that repository temporarily only when a Nvidia option is selected.

Nvidia `lib32` packages stay outside the default installation unless the final
package list adds gaming or 32-bit application support again.

## Terminal

- Install `zsh`, `zsh-completions`, `zsh-syntax-highlighting` and
  `zsh-autosuggestions`.
- Provide an Oh My Zsh-compatible `.zshrc` for the user created by Calamares.
- Set `/bin/zsh` as that user's default shell.
- Create an initial `.zshrc` using the `duellj` theme.
- Enable the `git`, `zsh-syntax-highlighting` and `zsh-autosuggestions`
  plugins.
- Ensure Konsole opens with the user's default shell.

## Packages

The final list should separate explicitly desired packages from transitive
dependencies.

Included as the base:

- Arch base system: `base`, kernel, firmware, microcode, Btrfs tools and GRUB.
- KDE Plasma through `plasma-meta`.
- Basic KDE tools such as Dolphin, Konsole, Ark, Gwenview, Okular, Spectacle,
  Discover, MPV and System Settings when they are not already pulled by the meta
  package.
- Network, audio, Bluetooth, firewall, XDG portals and Flatpak.
- Essential terminal and maintenance tools: `sudo`, `git`, `curl`, `wget`,
  `vim` or `nano`, `htop`, `ripgrep`, `openssh`, `usbutils`, `pciutils`,
  `smartmontools`, `unzip`, `zip`, `unrar`, `7zip`.
- Zsh and shell plugins defined in the Terminal section.

Excluded from the default:

- Steam.
- Heroic Games Launcher.
- GameMode.
- `lib32` packages used only by games.
- Brave.
- VS Code and other personal applications.

## Pending Decisions

- Final distro name and visual branding.
- Whether KDE should stay fully vanilla or receive small convenience tweaks.
- Exact explicit package list in `packages.x86_64`.
- Final policy for installing YAY in the ISO without creating a custom package
  repository.
- Whether the live ISO should use a default user/password or autologin.
