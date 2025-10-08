{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configurations.client.winboat = {
      enable = lib.mkEnableOption "Enables winboat module";
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.winboat;
    in
    lib.mkIf cfg.enable {
      users.groups.docker.members = [ "${config.system.user.general.primary}" ];
      virtualisation.docker.enable = true;

      environment.systemPackages =
        let
          winboat = import ./../../packages/derivations/winboat.nix {
            inherit (pkgs) lib fetchurl appimageTools;
          };
        in
        [
          pkgs.freerdp
          winboat
        ];

      home-manager.users.${config.system.user.general.primary} =
        { config, ... }:
        {
          # override default desktop entry, due to problems (opening twice after boot)
          xdg.desktopEntries = {
            winboat = {
              name = "winboat";
              exec = "WinBoat --no-sandbox %U";
              terminal = false;
              type = "Application";
              icon = "winboat";
              # startupWMClass = "winboat";
              # x-AppImage-Version = "0.8.6";
              comment = "Windows for Penguins";
              categories = [ "Utility" ];
            };
          };
        };
    };
}
