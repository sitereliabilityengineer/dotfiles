{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    envExtra = ''
      if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi
    '';

    sessionVariables = {
      HISTSIZE = "100000";
      SAVEHIST = "100000";
    };

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls --color=auto -ltra";
      k = "kubectl";
      lz = "lazygit";
      ld = "lazydocker";
      chrome = "chrome --disable-gpu --use-gl=angle --use-angle=swiftshader --enable-unsafe-swiftshader --no-sandbox >/dev/null 2>&1 &";
    };

    initContent = ''
      if [ -f "$HOME/.local_variables.env" ]; then
        source "$HOME/.local_variables.env"
      fi

      vaultenv() {
        source "$HOME/.vault/$1"
        echo "Vault activo en: $VAULT_ADDR"
      }
    '';
  };
}
