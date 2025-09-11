{ lib, config, ... }:
{
  options = {
    applications.configurations.client.kitty = {
      enable = lib.mkEnableOption "Enables Kitty module";
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.kitty;
    in
    lib.mkIf cfg.enable {
      environment.variables = {
        TERMINAL = "kitty";
      };
      programs.nautilus-open-any-terminal.terminal = "kitty";
      # Home Manager as NixOS module
      home-manager.users.${config.system.user.general.primary} =
        { config, ... }:
        {
          programs.kitty =
            let
              palette = config.colorScheme.palette;
            in
            {
              enable = true;
              font = {
                name = "UbuntuMonoNerdFont";
                size = 12;
              };
              settings = {
                confirm_os_window_close = 0;
                dynamic_background_opacity = false;
                enable_audio_bell = false;
                mouse_hide_wait = "-1.0";
                window_padding_width = 4;
                background_opacity = "0.8";
                background_blur = 1;
              };
              extraConfig = ''
                foreground #${palette.base05} 
                background #${palette.base01} 
                selection_foreground #${palette.base04} 
                selection_background #${palette.base0C} 
                color0 #${palette.base01} 
                color1 #${palette.base08} 
                color2 #${palette.base0B} 
                color3 #${palette.base0A} 
                color4 #${palette.base07} 
                color5 #${palette.base0E} 
                color6 #${palette.base0D} 
                color7 #${palette.base05} 
                color8 #${palette.base01} 
                color9 #${palette.base0F} 
                color10 #${palette.base0B} 
                color11 #${palette.base0A} 
                color12 #${palette.base0C} 
                color13 #${palette.base0E} 
                color14 #${palette.base0C} 
                color15 #${palette.base05} 

                # URL styles
                url_color #${palette.base0E} 
                url_style single

                # Cursor styles
                cursor #${palette.base05} 

                active_tab_foreground   #${palette.base05} 
                active_tab_background   #${palette.base0D} 
                inactive_tab_foreground #${palette.base05} 
                inactive_tab_background #${palette.base00} 
              '';
            };
        };
    };
}
