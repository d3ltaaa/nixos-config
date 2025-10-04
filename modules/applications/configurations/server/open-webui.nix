{
  lib,
  config,
  nixpkgs-stable,
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
        nixpkgs-stable.python313Packages.hf-xet
      ];
      services.open-webui = {
        enable = true;
        package = nixpkgs-stable.open-webui;
        host = "0.0.0.0";
        openFirewall = true;
      };

    };
}
