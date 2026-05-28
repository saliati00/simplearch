#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

if [ -n "${SUDO_USER:-}" ] && [ "$SUDO_USER" != "root" ]; then
  DEFAULT_HOME="$(getent passwd "$SUDO_USER" | cut -d: -f6)"
else
  DEFAULT_HOME="$HOME"
fi

BUILD_ROOT="${BUILD_ROOT:-$DEFAULT_HOME/simplearch-build}"
WORK_DIR="$BUILD_ROOT/work"
OUT_DIR="$BUILD_ROOT/out"
LOCAL_REPO="$BUILD_ROOT/localrepo"
OPTIONAL_REPO="$BUILD_ROOT/optional-repo"
PROFILE_DIR="$BUILD_ROOT/profile"

if ! command -v mkarchiso >/dev/null 2>&1; then
  echo "mkarchiso nao encontrado. Instale o pacote archiso primeiro:" >&2
  echo "  sudo pacman -S --needed archiso" >&2
  exit 1
fi

if ! sudo -n true 2>/dev/null; then
  echo "sudo precisa estar autenticado no terminal que executa este script." >&2
  echo "Rode primeiro:" >&2
  echo "  sudo -v" >&2
  echo "Depois execute novamente:" >&2
  echo "  ./scripts/build-iso.sh" >&2
  exit 1
fi

mkdir -p "$WORK_DIR" "$OUT_DIR"

if [ ! -f "$LOCAL_REPO/simplearch-local.db" ] && [ ! -f "$LOCAL_REPO/simplearch-local.db.tar.gz" ]; then
  "$REPO_ROOT/scripts/build-local-repo.sh"
fi

if [ ! -f "$OPTIONAL_REPO/simplearch-optional.db" ] && [ ! -f "$OPTIONAL_REPO/simplearch-optional.db.tar.zst" ]; then
  "$REPO_ROOT/scripts/build-optional-repo.sh"
fi

rm -rf "$PROFILE_DIR"
cp -a "$REPO_ROOT/archiso" "$PROFILE_DIR"

mkdir -p "$PROFILE_DIR/airootfs/opt/simplearch/offline-repo"
cp -a "$OPTIONAL_REPO"/. "$PROFILE_DIR/airootfs/opt/simplearch/offline-repo/"

pacman_conf="$PROFILE_DIR/pacman.conf"
{
  echo "[simplearch-local]"
  echo "SigLevel = Optional TrustAll"
  echo "Server = file://$LOCAL_REPO"
  echo
  cat "$pacman_conf"
} > "$pacman_conf.tmp"
mv "$pacman_conf.tmp" "$pacman_conf"

exec sudo mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" "$PROFILE_DIR"
