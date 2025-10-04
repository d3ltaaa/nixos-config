{
  lib,
  config,
  nixpkgs-stable,
  ...
}:
{
  options = {
    applications.configurations.server.jellyfin = {
      enable = lib.mkEnableOption "Enables jellyfin";
    };
  };

  config =
    let
      cfg = config.applications.configurations.server.jellyfin;
    in
    lib.mkIf cfg.enable {
      services.jellyfin = {
        enable = true;
        package = nixpkgs-stable.jellyfin;
        openFirewall = true;
      };
    };
}
