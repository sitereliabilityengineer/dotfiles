{ pkgs, ... }:

{
  home.packages = with pkgs; [
    htop jq yq-go ripgrep fzf zoxide
    uv ruff ty httpie
    docker docker-compose
    lazydocker lazygit k9s ansible opentofu openbao
    nerd-fonts.meslo-lg nerd-fonts.fira-code nerd-fonts.jetbrains-mono
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
