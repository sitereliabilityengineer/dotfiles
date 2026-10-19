#!/usr/bin/env bash
#
# keep_alive_teams.sh
# Mantiene el estado activo en Teams enviando la tecla F15 a Windows desde WSL.

INTERVAL=60 # Intervalo en segundos

echo "=========================================="
echo " Keeping Teams Active via WSL -> PowerShell"
echo " Presiona [CTRL+C] para detener el script."
echo "=========================================="

# Limpieza al salir
trap 'echo -e "\nScript detenido."; exit 0' INT TERM

while true; do
    # Llama a powershell.exe desde WSL enviando la pulsación de F15
    /mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/powershell.exe -NoProfile -NonInteractive -Command \
      '$wshell = New-Object -ComObject WScript.Shell; $wshell.SendKeys("{SCROLLLOCK}{SCROLLLOCK}")'
    
    echo "[$(date +'%H:%M:%S')] Pulsación simulada enviada a Windows."
    sleep "$INTERVAL"
done
