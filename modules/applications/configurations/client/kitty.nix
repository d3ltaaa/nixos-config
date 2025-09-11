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
              settings = {
                confirm_os_window_close = 0;
                dynamic_background_opacity = true;
                enable_audio_bell = false;
                mouse_hide_wait = "-1.0";
                window_padding_width = 10;
                background_opacity = "0.5";
                background_blur = 5;
              };
            };
        };
    };
}
