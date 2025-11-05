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
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        WLR_RENDERER_ALLOW_SOFTWARE = 1;
      };
      home-manager.users.${config.system.user.general.primary} =
        { config, ... }:
        {
          xdg.mimeApps = {
            enable = true;
            defaultApplications = {
              "application/gzip" = [ "com.github.flxzt.rnote.desktop" ];
            };
          };
        };
    };
}
