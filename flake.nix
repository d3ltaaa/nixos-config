{
  inputs = {
    # unstable -> pkgs
    pkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # stable -> pkgs-alt
    pkgs-alt.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "pkgs";

    nixvim.url = "github:nix-community/nixvim";
    nvf.url = "github:notashelf/nvf";

    nix-colors.url = "github:misterio77/nix-colors";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    winboat.url = "github:TibixDev/winboat";

    scripts.url = "github:d3ltaaa/fscripts";
    scripts.flake = false;
  };
  outputs =
    {
      pkgs,
      pkgs-alt,
      ...
    }@inputs:
    let
      user = "falk";
    in
    {
      nixosConfigurations = {
        "FW13" = pkgs.lib.nixosSystem {
          # pkgs-alt -> pkgs
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            pkgs-alt = import pkgs-alt {
              config.allowUnfree = true;
            };
          };
          modules = [
            ./hosts/FW13/configuration.nix
            ./modules/default.nix
            inputs.nixos-hardware.nixosModules.framework-13-7040-amd
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.users.${user}.imports = [
                inputs.nixvim.homeManagerModules.nixvim
              ];
            }
          ];
        };
        "PC" = pkgs.lib.nixosSystem {
          # pkgs-alt -> pkgs
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            pkgs-alt = import pkgs-alt {
              config.allowUnfree = true;
            };
          };
          modules = [
            ./hosts/PC/configuration.nix
            ./modules/default.nix
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.users.${user}.imports = [
                inputs.nixvim.homeManagerModules.nixvim
                inputs.nvf.homeManagerModules.default
              ];
            }
          ];
        };
        "VM1" = pkgs.lib.nixosSystem {
          # pkgs-alt -> pkgs
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            pkgs-alt = import pkgs-alt {
              config.allowUnfree = true;
            };
          };
          modules = [
            ./hosts/VM1/configuration.nix
            ./modules/default.nix
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.users.${user}.imports = [
                inputs.nixvim.homeManagerModules.nixvim
              ];
            }
          ];
        };
        "VM2" = pkgs.lib.nixosSystem {
          # pkgs-alt -> pkgs
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            pkgs-alt = import pkgs-alt {
              config.allowUnfree = true;
            };
          };
          modules = [
            ./hosts/VM2/configuration.nix
            ./modules/default.nix
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.users.${user}.imports = [
                inputs.nixvim.homeManagerModules.nixvim
              ];
            }
          ];
        };
      };
    };
}
