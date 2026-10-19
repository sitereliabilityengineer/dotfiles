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
      # Se omite el antiguo alias de Chrome con --no-sandbox:
      # si hay problemas de GPU en WSL, configurar un lanzador específico.
    };

    initContent = ''
      if [ -f "$HOME/.local_variables.env" ]; then
        source "$HOME/.local_variables.env"
      fi

      vaultenv() {
        if (( $# != 1 )) || [[ -z "$1" || "$1" == *'/'* || "$1" == .* ]]; then
          print -u2 'Uso: vaultenv <perfil> (nombre simple dentro de ~/.vault)'
          return 2
        fi
        local profile="$HOME/.vault/$1"
        if [[ ! -f "$profile" || ! -r "$profile" ]]; then
          print -u2 "Perfil no disponible: $profile"
          return 1
        fi
        # Los perfiles son scripts de confianza controlados por el usuario.
        source "$profile" || return
        print "Vault activo en: ''${VAULT_ADDR:-sin VAULT_ADDR}"
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
