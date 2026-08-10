{ config, pkgs, usuario, ... }:

{
  imports = [
    ../../modules/shell/zsh.nix
    ../../modules/tools/cli.nix
    ../../modules/services/background.nix
  ];

  # ===========================================================================
  # 1. IDENTIFICACIÓN Y ESTADO BASE
  # ===========================================================================
  home.username = "${usuario}";
  home.homeDirectory = "/home/${usuario}";
  home.stateVersion = "26.05"; # No cambiar nunca en este entorno

  # ===========================================================================
  # 2. RUTAS Y VARIABLES GLOBALES
  # ===========================================================================
  # Home Manager inyectará estas rutas al principio de tu $PATH automáticamente
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/bin"
  ];

  # Habilitar fontconfig para que las fuentes funcionen en Linux nativo (sin WSL)
  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;
  # Le dice a HM que configure las rutas XDG y Systemd para un Linux normal
  targets.genericLinux.enable = true;
}
