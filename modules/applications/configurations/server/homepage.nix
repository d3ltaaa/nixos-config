{
  lib,
  config,
  nixpkgs-stable,
  ...
}:
{
  options = {
    applications.configurations.server.homepage = {
      enable = lib.mkEnableOption "Enables Homepage module";
      widgets = lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        default = [ ];
      };
      bookmarks = lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        default = [ ];
      };
      services = lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        default = [ ];
      };
    };
  };

  config =
    let
      cfg = config.applications.configurations.server.homepage;
    in
    lib.mkIf cfg.enable {
      services.homepage-dashboard = {
        enable = true;
        package = nixpkgs-stable.homepage-dashboard;
        allowedHosts = "${config.system.networking.general.staticIp}:8082,home.${config.secrets.serverAddress}";
        openFirewall = true;
        widgets = cfg.widgets;
        bookmarks = cfg.bookmarks;
        services = cfg.services;
      };
    };
}
