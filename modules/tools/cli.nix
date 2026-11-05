{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Sistema y utilidades
    git
    curl
    wget
    unzip
    htop
    btop
    jq
    yq-go
    ripgrep
    fzf
    zoxide

    # Desarrollo
    uv
    ruff
    ty
    httpie
    shellcheck
    yamllint

    # Contenedores
    docker
    docker-compose
    lazydocker

    # Git
    lazygit

    # Kubernetes
    kubectl
    kubernetes-helm
    kubectx
    k9s
    stern
    kustomize

    # IaC y automatización
    ansible
    opentofu
    openbao

    # Seguridad
    sops
    age

    # Fuentes
    nerd-fonts.meslo-lg
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    useTheme = "powerlevel10k_classic";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    historyLimit = 10000;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.bat.enable = true;
}
