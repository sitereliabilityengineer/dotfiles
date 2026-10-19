{ usuario, ... }:

{
  # Opciones compartidas por WSL y Linux nativo.
  imports = [
    ../modules/shell/zsh.nix
    ../modules/tools/cli.nix
  ];

  home.username = usuario;
  home.homeDirectory = "/home/${usuario}";
  # No incrementar stateVersion durante actualizaciones ordinarias.
  home.stateVersion = "26.05";

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/bin"
  ];

  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;
}
