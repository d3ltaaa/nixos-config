{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    XXX = {
      enable = lib.mkEnableOption "Enables Spotify module";
    };
  };

  config =
    let
      cfg = config.XXX;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [ spotify ];
      services.playerctld.enable = true;
      networking.networkmanager.settings.connectivity.uri =
        "http://nmcheck.gnome.org/check_network_status.txt"; # fix for spotify (always showed connectivity limited)
    };
}
