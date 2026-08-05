{
  description = "Mi entorno de Home Manager con Flakes";

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
      # Definimos el usuario UNA SOLA VEZ aquí
      usuario = "koteo"; 
      pkgs = import nixpkgs { 
  	inherit system; 
  	config.allowUnfree = true; 
      };
    in {
    homeConfigurations.${usuario} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      
      # Inyectamos la variable "usuario" para que home.nix pueda leerla
      extraSpecialArgs = { inherit usuario; }; 
      
      modules = [ 
        ./home.nix 
      ];
    };
  };
}
