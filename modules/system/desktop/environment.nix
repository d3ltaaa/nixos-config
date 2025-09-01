{ lib, config, ... }:
{
  options = {
    system.desktop.environment = {
      enable = lib.mkEnableOption "Enables Environment-Variables";
    };
  };
  config =
    let
      cfg = config.system.desktop.environment;
    in
    lib.mkIf cfg.enable {
      environment.variables = {
        ELECTRON_OZONE_PLATFORM_HINT = "auto"; # TODO does that belong here?
        WLR_RENDERER_ALLOW_SOFTWARE = 1;
      };
    };
}
