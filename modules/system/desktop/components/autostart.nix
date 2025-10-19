{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.components.autostart.enable = lib.mkEnableOption "Enables the autostart script";
  };

  config =
    let
      cfg = config.system.desktop.components.autostart;
      cfg-components = config.system.desktop.components;
    in
    lib.mkIf cfg.enable {

      environment.systemPackages = [
        (pkgs.writeScriptBin "autostart-script" ''
          ${lib.optionalString
            (
              (cfg-components.hyprlock.enable || cfg-components.niri.enable)
              && !cfg-components.greetd.enable
              && !cfg-components.ly.enable
            )
            ''
              hyprlock &
            ''
          }

          ${lib.optionalString cfg-components.swww.enable ''
            swww-daemon &
            swww restore &
          ''}

          ${lib.optionalString cfg-components.hyprland.enable ''
            reload -n 
          ''}

          ${lib.optionalString cfg-components.hyprpolkitagent.enable ''
            systemctl --user start hyprpolkitagent
          ''}
        '')
      ];
    };
}
