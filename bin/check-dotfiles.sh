#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if ! command -v nix >/dev/null 2>&1; then
  echo 'Nix no está instalado o no está en PATH' >&2
  exit 127
fi
for profile in 'koteo@wsl' 'koteo@generico'; do
  echo "==> Evaluando y construyendo $profile"
  nix build --no-link ".#homeConfigurations.\"${profile}\".activationPackage"
done
echo 'Los dos perfiles se construyeron correctamente.'
