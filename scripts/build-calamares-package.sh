#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
PKG_DIR="$REPO_ROOT/packages/calamares"

if [ ! -f "$REPO_ROOT/vendor/calamares-3.4.2.tar.gz" ]; then
  echo "Arquivo vendor/calamares-3.4.2.tar.gz nao encontrado." >&2
  exit 1
fi

if ! command -v makepkg >/dev/null 2>&1; then
  echo "makepkg nao encontrado. Instale base-devel primeiro." >&2
  exit 1
fi

if ! sudo -n true 2>/dev/null; then
  echo "sudo precisa estar autenticado no terminal que executa este script." >&2
  echo "Rode primeiro:" >&2
  echo "  sudo -v" >&2
  echo "Depois execute novamente:" >&2
  echo "  ./scripts/build-calamares-package.sh" >&2
  exit 1
fi

cd "$PKG_DIR"
exec makepkg -s --needed
