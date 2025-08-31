{ lib, config, ... }:
{
  options = {
    system.desktop.hyprland-desktop.dconf = {
      enable = lib.mkEnableOption "Enables dconf";
    };
  };

  config =
    let
      cfg = config.system.desktop.hyprland-desktop.dconf;
    in
    lib.mkIf cfg.enable {
      programs.dconf.enable = true;
    };
}
