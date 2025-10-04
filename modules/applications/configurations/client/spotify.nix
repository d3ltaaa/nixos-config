{
  lib,
  config,
  nixpkgs-stable,
  ...
}:
{
  options = {
    applications.configurations.client.spotify = {
      enable = lib.mkEnableOption "Enables Spotify module";
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.spotify;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = with nixpkgs-stable; [ spotify ];
      services.playerctld.enable = true;
      networking.networkmanager.settings.connectivity.uri =
        "http://nmcheck.gnome.org/check_network_status.txt"; # fix for spotify (always showed connectivity limited)
    };
}
