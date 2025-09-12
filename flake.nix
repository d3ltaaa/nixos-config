{
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-stable";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs-stable";

    nix-colors.url = "github:misterio77/nix-colors";
    # nix-colors.inputs.nixpkgs.follows = "nixpkgs-stable";

    nix-flatpak.url = "github:gmodena/nix-flatpak"; # stable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.

    scripts.url = "github:d3ltaaa/fscripts";
    scripts.flake = false;

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
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
        "FW13" = nixpkgs-stable.lib.nixosSystem {
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
            ./hosts/FW13/configuration.nix
            ./modules/default.nix
            inputs.nixos-hardware.nixosModules.framework-13-7040-amd
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
      };
    };
}
