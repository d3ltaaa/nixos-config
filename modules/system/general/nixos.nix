{ lib, config, ... }:
{
  options = {
    system.general.nixos = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "NIXOS";
      };
      nixosStateVersion = lib.mkOption {
        type = lib.types.str;
        default = "25.05";
      };
      homeManagerStateVersion = lib.mkOption {
        type = lib.types.str;
        default = "25.05";
      };
    };
  };

  config =
    let
      cfg = config.system.general.nixos;
    in
    {
      networking.hostName = cfg.name;

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      system.stateVersion = cfg.nixosStateVersion;

      home-manager.users.${config.system.user.general.primary} =
        let
          nixos-config = config;
        in
        { ... }:
        {

          programs.home-manager.enable = true;

          home.username = "${nixos-config.system.user.general.primary}";
          home.homeDirectory = "/home/${nixos-config.system.user.general.primary}";

          home.stateVersion = cfg.homeManagerStateVersion;
        };
    };
}
