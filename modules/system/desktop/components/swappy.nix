{ lib, config, ... }:
{
  options = {
    system.desktop.components.swappy.enable = lib.mkEnableOption "Enables Swappy Module";
  };

  config =
    let
      cfg = config.system.desktop.components.swappy;
      cfg-hyprland = config.system.desktop.components;
    in
    lib.mkIf cfg.enable {
      home-manager.users.${config.system.user.general.primary} =
        { config, ... }:
        let
          nixos-cfg-hyprland = cfg-hyprland;
        in
        {
          xdg.configFile."swappy/config".text = ''
            [Default]
            save_dir=${config.xdg.userDirs.extraConfig.XDG_SCREENSHOT_DIR}
            save_filename_format=swappy-%Y%m%d-%H%M%S.png
            show_panel=false
            line_size=5
            text_size=20
            text_font=sans-serif
            paint_mode=brush
            early_exit=false
            fill_shape=false
            auto_save=false
            custom_color=rgba(193,125,17,1)
          '';
          wayland.windowManager.hyprland = lib.mkIf nixos-cfg-hyprland.enable {
            settings = {
              bind = [
                "$mod, Q, exec, grim -g \"$(slurp)\" - | swappy -f -"
              ];
            };
          };
        };
    };
}
