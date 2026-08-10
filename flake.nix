{
  description = "Mi entorno de Home Manager multinodo";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: 
    let
      system = "x86_64-linux";
      usuario = "koteo"; 
      pkgs = import nixpkgs { 
        inherit system; 
        config.allowUnfree = true; 
      };
      extraSpecialArgs = { inherit usuario; }; 
    in {
    homeConfigurations = {
      
      # 1. Tu máquina de trabajo diaria en WSL
      "${usuario}@wsl" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;
        modules = [ ./hosts/wsl/home.nix ];
      };

      # 2. Cualquier otro Linux nativo o servidor
      "${usuario}@generico" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;
        modules = [ ./hosts/linux/home.nix ];
      };
      
    };
  };
}
