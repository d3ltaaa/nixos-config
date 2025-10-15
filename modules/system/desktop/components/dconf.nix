{ lib, config, ... }:
{
  options = {
    system.desktop.components.dconf = {
      enable = lib.mkEnableOption "Enables dconf";
    };
  };

  config =
    let
      cfg = config.system.desktop.components.dconf;
    in
    lib.mkIf cfg.enable {
      programs.dconf.enable = true;
    };
}
