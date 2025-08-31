{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configurations.server.open-webui = {
      enable = lib.mkEnableOption "Enables Open-webui module";

    };
  };

  config =
    let
      cfg = config.applications.configurations.server.open-webui;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [
        pkgs.python313Packages.hf-xet
      ];
      services.open-webui = {
        enable = true;
        package = pkgs.open-webui;
        host = "0.0.0.0";
        openFirewall = true;
      };

    };
}
