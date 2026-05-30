#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
PKG_DIR="$REPO_ROOT/packages/calamares"

if [ ! -f "$REPO_ROOT/vendor/calamares-3.4.2.tar.gz" ]; then
  echo "File vendor/calamares-3.4.2.tar.gz not found." >&2
  exit 1
fi

if ! command -v makepkg >/dev/null 2>&1; then
  echo "makepkg not found. Install base-devel first." >&2
  exit 1
fi

if ! sudo -n true 2>/dev/null; then
  echo "sudo must be authenticated in the terminal running this script." >&2
  echo "Run first:" >&2
  echo "  sudo -v" >&2
  echo "Then run again:" >&2
  echo "  ./scripts/build-calamares-package.sh" >&2
  exit 1
fi

cd "$PKG_DIR"
exec makepkg -s --needed
