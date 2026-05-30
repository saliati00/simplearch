#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

if [ -n "${SUDO_USER:-}" ] && [ "$SUDO_USER" != "root" ]; then
  DEFAULT_HOME="$(getent passwd "$SUDO_USER" | cut -d: -f6)"
else
  DEFAULT_HOME="$HOME"
fi

BUILD_ROOT="${BUILD_ROOT:-$DEFAULT_HOME/simplearch-build}"
LOCAL_REPO="$BUILD_ROOT/localrepo"
REPO_DB="$LOCAL_REPO/simplearch-local.db.tar.gz"

if ! command -v repo-add >/dev/null 2>&1; then
  echo "repo-add not found. Install pacman-contrib first." >&2
  exit 1
fi

mkdir -p "$LOCAL_REPO"

mapfile -t packages < <(
  find "$REPO_ROOT/packages" -type f -name '*.pkg.tar.*' ! -name '*-debug-*' | sort
)

if [ "${#packages[@]}" -eq 0 ]; then
  echo "No local packages found in packages/." >&2
  echo "Build Calamares first:" >&2
  echo "  ./scripts/build-calamares-package.sh" >&2
  exit 1
fi

copied_packages=()
for package_file in "${packages[@]}"; do
  package_name="$(basename "$package_file")"
  cp -f "$package_file" "$LOCAL_REPO/$package_name"
  copied_packages+=("$LOCAL_REPO/$package_name")
done

repo-add "$REPO_DB" "${copied_packages[@]}"

echo "Local repository created at: $LOCAL_REPO"
