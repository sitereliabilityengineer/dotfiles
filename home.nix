{ config, pkgs, usuario, ... }:

{
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

  # ===========================================================================
  # 3. PAQUETERÍA GENERAL
  # ===========================================================================
  home.packages = with pkgs; [
    # Utilidades de sistema y búsqueda
    htop
    jq
    yq-go
    ripgrep
    
    # Entorno Python (rápido y moderno)
    uv
    ruff
    ty
    
    # Herramientas TUI para DevOps
    lazydocker
    lazygit
    k9s
    
    # Tipografías para Oh My Posh
    nerd-fonts.meslo-lg
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  # ===========================================================================
  # 4. CONFIGURACIÓN DE VS CODE (Deshabilitado para WSL)
  # ===========================================================================
  # NOTA: En entornos WSL, VS Code debe instalarse en el Windows anfitrión 
  # para usar su interfaz gráfica, conectándose a Linux mediante la extensión "WSL".
  # 
  # programs.vscode = { ... };

  # ===========================================================================
  # 5. ZSH: CONFIGURACIÓN DE LA TERMINAL
  # ===========================================================================
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;     # Sugerencias en gris basadas en el historial
    syntaxHighlighting.enable = true; # Comandos válidos en verde, errores en rojo

    # envExtra se ejecuta muy pronto. Ideal para cargar el entorno de Nix.
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
      # Ejecución de Chrome en background silenciando logs y desvinculando la terminal
      chrome = "chrome --disable-gpu --use-gl=angle --use-angle=swiftshader --enable-unsafe-swiftshader --no-sandbox >/dev/null 2>&1 &";
    };

    # initContent se ejecuta al arrancar una terminal interactiva (tus scripts y funciones)
    initContent = ''
      # Cargar variables locales y secretas excluidas de Git
      if [ -f "$HOME/.local_variables.env" ]; then
        source "$HOME/.local_variables.env"
      fi

      # Función para inyectar entornos de HashiCorp Vault
      vaultenv() {
        source "$HOME/.vault/$1"
        echo "Vault activo en: $VAULT_ADDR"
      }
    '';
  };

  # ===========================================================================
  # 6. PROGRAMAS MODULARIZADOS
  # ===========================================================================
  
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    useTheme = "powerlevel10k_classic";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true; # Activa Ctrl+R para buscar en el historial interactivamente
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    historyLimit = 10000;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true; # Configura variables como $EDITOR automáticamente
  };

  programs.bat.enable = true;    # Alternativa a cat con resaltado de sintaxis
  programs.direnv.enable = true; # Inyecta variables por directorio (se auto-integra con Zsh)

  programs.home-manager.enable = true;
}
