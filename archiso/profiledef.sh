#!/usr/bin/env bash

iso_name="simplearch"
iso_label="SARCH_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="Simple Arch <https://github.com/saliati00/simplearch>"
iso_application="Simple Arch Live/Rescue DVD"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="simplearch"
buildmodes=('iso')
bootmodes=(
  'bios.syslinux'
  'uefi.systemd-boot'
)
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')

file_permissions=(
  ['/etc/hostname']='0:0:644'
  ['/etc/environment']='0:0:644'
  ['/etc/locale.conf']='0:0:644'
  ['/etc/locale.gen']='0:0:644'
  ['/etc/machine-id']='0:0:444'
  ['/etc/profile.d/simplearch-locale.sh']='0:0:644'
  ['/etc/xdg/kded6rc']='0:0:644'
  ['/etc/xdg/plasma-localerc']='0:0:644'
  ['/etc/xdg/plasma-welcomerc']='0:0:644'
  ['/etc/xdg/kdeglobals']='0:0:644'
  ['/etc/vconsole.conf']='0:0:644'
  ['/etc/plasmalogin.conf']='0:0:644'
  ['/etc/skel/Desktop/simplearch-install.desktop']='0:0:755'
  ['/etc/skel/.config/kded6rc']='0:0:644'
  ['/etc/skel/.config/plasma-localerc']='0:0:644'
  ['/etc/skel/.config/plasma-welcomerc']='0:0:644'
  ['/etc/skel/.config/kdeglobals']='0:0:644'
  ['/etc/skel/.zshrc']='0:0:644'
  ['/etc/polkit-1/rules.d/49-simplearch-calamares.rules']='0:0:644'
  ['/etc/NetworkManager/system-connections/simplearch-wired.nmconnection']='0:0:600'
  ['/etc/pacman.d/hooks/99-simplearch-hide-upstream-calamares-launcher.hook']='0:0:644'
  ['/etc/calamares/settings.conf']='0:0:644'
  ['/etc/calamares/modules/welcome.conf']='0:0:644'
  ['/etc/calamares/modules/locale.conf']='0:0:644'
  ['/etc/calamares/modules/partition.conf']='0:0:644'
  ['/etc/calamares/modules/mount.conf']='0:0:644'
  ['/etc/calamares/modules/unpackfs.conf']='0:0:644'
  ['/etc/calamares/modules/fstab.conf']='0:0:644'
  ['/etc/calamares/modules/users.conf']='0:0:644'
  ['/etc/calamares/modules/displaymanager.conf']='0:0:644'
  ['/etc/calamares/modules/services-systemd.conf']='0:0:644'
  ['/etc/calamares/modules/packagechooser-gpu.conf']='0:0:644'
  ['/etc/calamares/modules/shellprocess-gpu.conf']='0:0:644'
  ['/etc/calamares/modules/shellprocess-postinstall.conf']='0:0:644'
  ['/etc/calamares/modules/initcpiocfg.conf']='0:0:644'
  ['/etc/calamares/modules/bootloader.conf']='0:0:644'
  ['/etc/calamares/modules/finished.conf']='0:0:644'
  ['/etc/sudoers.d/10-simplearch']='0:0:440'
  ['/etc/sysusers.d/simplearch.conf']='0:0:644'
  ['/etc/tmpfiles.d/simplearch.conf']='0:0:644'
  ['/etc/systemd/zram-generator.conf']='0:0:644'
  ['/root']='0:0:750'
  ['/usr/share/applications/simplearch-install.desktop']='0:0:644'
  ['/usr/local/bin/simplearch-apply-gpu-driver']='0:0:755'
  ['/usr/local/bin/simplearch-preflight']='0:0:755'
  ['/usr/local/bin/simplearch-postinstall']='0:0:755'
  ['/usr/share/calamares/branding/simplearch/branding.desc']='0:0:644'
  ['/usr/share/calamares/branding/simplearch/show.qml']='0:0:644'
  ['/usr/share/calamares/branding/simplearch/stylesheet.qss']='0:0:644'
  ['/usr/share/calamares/branding/simplearch/gpu-mesa.svg']='0:0:644'
  ['/usr/share/calamares/branding/simplearch/gpu-nvidia.svg']='0:0:644'
  ['/usr/share/calamares/branding/simplearch/gpu-nvidia-open.svg']='0:0:644'
)
