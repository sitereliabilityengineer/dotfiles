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

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      mkHome = { usuario, modulo }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit usuario;
          };

          modules = [ modulo ];
        };

    in {
      homeConfigurations = {

        "koteo@wsl" = mkHome {
          usuario = "koteo";
          modulo = ./hosts/wsl/home.nix;
        };

        "koteo@generico" = mkHome {
          usuario = "ircd";
          modulo = ./hosts/linux/home.nix;
        };

      };
    };
}
