{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.hyprland-desktop.cliphist.enable = lib.mkEnableOption "Enables Cliphist module";
  };

  config =
    let
      cfg = config.system.desktop.hyprland-desktop.cliphist;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        nwg-clipman
        wl-clipboard
      ];
      home-manager.users.${config.system.user.general.primary} =
        { ... }:
        {
          services.cliphist.enable = true;
          services.cliphist.package = pkgs.cliphist;
        };
    };
}
