#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if ! command -v nix >/dev/null 2>&1; then
  echo "ERROR: Nix no está instalado o no está en PATH" >&2
  exit 127
fi

profiles=(
  "koteo@wsl"
  "koteo@generico"
)

for profile in "${profiles[@]}"; do
  echo
  echo "==> Validando: $profile"

  if ! nix build --no-link \
    ".#homeConfigurations.\"${profile}\".activationPackage"; then
    echo "ERROR: Falló el perfil $profile" >&2
    exit 1
  fi

  echo "OK: $profile"
done

echo
echo "Todos los perfiles se construyeron correctamente."
