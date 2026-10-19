{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 100000;
      save = 100000;
      append = true;
      share = false; 
      ignoreDups = true;
      ignoreSpace = false;
      expireDuplicatesFirst = true;
      extended = true;
    };
    
    setOptions = [
      "INC_APPEND_HISTORY"
    ];
    
    defaultKeymap = "emacs";

    oh-my-zsh = {
      enable = true;
      theme = ""; 
    };

    envExtra = ''
      if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi
    '';

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

      for seq in '\e[H' '\eOH' '\e[1~' '\e[7~'; do
        bindkey "$seq" beginning-of-line
      done

      for seq in '\e[F' '\eOF' '\e[4~' '\e[8~'; do
        bindkey "$seq" end-of-line
      done
    '';
  };
}
