#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

if [ -n "${SUDO_USER:-}" ] && [ "$SUDO_USER" != "root" ]; then
  DEFAULT_HOME="$(getent passwd "$SUDO_USER" | cut -d: -f6)"
else
  DEFAULT_HOME="$HOME"
fi

BUILD_ROOT="${BUILD_ROOT:-$DEFAULT_HOME/simplearch-build}"
OPTIONAL_PACKAGES_FILE="${OPTIONAL_PACKAGES_FILE:-$REPO_ROOT/archiso/optional-packages.x86_64}"
OPTIONAL_REPO="${OPTIONAL_REPO:-$BUILD_ROOT/optional-repo}"
OPTIONAL_DB="$BUILD_ROOT/optional-pacman-db"
PACMAN_CONF="${PACMAN_CONF:-$REPO_ROOT/archiso/pacman.conf}"
REPO_DB="$OPTIONAL_REPO/simplearch-optional.db.tar.zst"

if [ ! -f "$OPTIONAL_PACKAGES_FILE" ]; then
  echo "Optional packages file not found: $OPTIONAL_PACKAGES_FILE" >&2
  exit 1
fi

if ! command -v repo-add >/dev/null 2>&1; then
  echo "repo-add not found. Install pacman-contrib first." >&2
  exit 1
fi

if ! sudo -n true 2>/dev/null; then
  echo "sudo must be authenticated to download optional packages with pacman." >&2
  echo "Run first:" >&2
  echo "  sudo -v" >&2
  exit 1
fi

mapfile -t optional_packages < <(sed '/^[[:blank:]]*#.*/d;s/#.*//;/^[[:blank:]]*$/d' "$OPTIONAL_PACKAGES_FILE")

if [ "${#optional_packages[@]}" -eq 0 ]; then
  echo "No optional packages defined in $OPTIONAL_PACKAGES_FILE" >&2
  exit 1
fi

mkdir -p "$OPTIONAL_REPO" "$OPTIONAL_DB/sync"

sudo pacman -Syw --noconfirm \
  --config "$PACMAN_CONF" \
  --dbpath "$OPTIONAL_DB" \
  --logfile "$BUILD_ROOT/optional-pacman.log" \
  --cachedir "$OPTIONAL_REPO" \
  "${optional_packages[@]}"

mapfile -t repo_packages < <(find "$OPTIONAL_REPO" -maxdepth 1 -type f -name '*.pkg.tar.*' ! -name '*.sig' | sort)

if [ "${#repo_packages[@]}" -eq 0 ]; then
  echo "No packages were downloaded to $OPTIONAL_REPO" >&2
  exit 1
fi

rm -f "$OPTIONAL_REPO"/simplearch-optional.db*
repo-add "$REPO_DB" "${repo_packages[@]}"

echo "Optional repository created at $OPTIONAL_REPO"
