{
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-stable";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs-stable";

    nix-colors.url = "github:misterio77/nix-colors";
    nix-colors.inputs.nixpkgs.follows = "nixpkgs-stable";

    nix-flatpak.url = "github:gmodena/nix-flatpak"; # stable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.

    scripts.url = "github:d3ltaaa/fscripts";
    scripts.flake = false;

  };
  outputs =
    {
      nixpkgs-unstable,
      nixpkgs-stable,
      scripts,
      ...
    }@inputs:
    let
      user = "falk";
    in
    {
      nixosConfigurations = {
        "VM" = nixpkgs-stable.lib.nixosSystem {
          # nixpkgs-stable -> pkgs
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit scripts;
            nixpkgs-unstable = import nixpkgs-unstable {
              config.allowUnfree = true;
            };
          };
          modules = [
            ./hosts/VM/configuration.nix
            ./modules/default.nix
            inputs.home-manager.nixosModules.home-manager
            inputs.nix-flatpak.nixosModules.nix-flatpak
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

        "T440P" = nixpkgs-stable.lib.nixosSystem {
          # nixpkgs-stable -> pkgs
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit scripts;
            nixpkgs-unstable = import nixpkgs-unstable {
              config.allowUnfree = true;
            };
          };
          modules = [
            ./hosts/T440P/configuration.nix
            ./modules/default.nix
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

        "PC" = nixpkgs-stable.lib.nixosSystem {
          # nixpkgs-stable -> pkgs
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit scripts;
            nixpkgs-unstable = import nixpkgs-unstable {
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
              ];
            }
          ];
        };

        "WIREGUARD-SERVER" = nixpkgs-stable.lib.nixosSystem {
          # nixpkgs-stable -> pkgs
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit scripts;
            nixpkgs-unstable = import nixpkgs-unstable {
              config.allowUnfree = true;
            };
          };
          modules = [
            ./hosts/WIREGUARD-SERVER/configuration.nix
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

        "SERVER" = nixpkgs-stable.lib.nixosSystem {
          # nixpkgs-stable -> pkgs
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit scripts;
            nixpkgs-unstable = import nixpkgs-unstable {
              config.allowUnfree = true;
            };
          };
          modules = [
            ./hosts/SERVER/configuration.nix
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

        "PC-SERVER" = nixpkgs-stable.lib.nixosSystem {
          # nixpkgs-stable -> pkgs
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit scripts;
            nixpkgs-unstable = import nixpkgs-unstable {
              config.allowUnfree = true;
              system = "x86_64-linux"; # ?
            };
          };
          modules = [
            ./hosts/PC-SERVER/configuration.nix
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
