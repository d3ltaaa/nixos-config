{ lib, config, ... }:
{
  options = {
    system.user.directories = {
      enable = lib.mkEnableOption "Enables User directories";
    };
  };

  config =
    let
      cfg = config.system.user.directories;
      primaryUser = config.system.user.general.primary;
    in
    lib.mkIf cfg.enable {
      home-manager.users.${primaryUser} =
        { config, ... }:
        {
          xdg.userDirs = {
            enable = true;
            createDirectories = true;
            documents = "/home/${primaryUser}/Dokumente";
            download = "/home/${primaryUser}/Downloads";
            pictures = "/home/${primaryUser}/Bilder";
            music = "/home/${primaryUser}/Audio";
            videos = "/home/${primaryUser}/Videos";
            templates = null;
            publicShare = null;
            desktop = null;
            extraConfig = {
              XDG_SCREENSHOT_DIR = "/home/${primaryUser}/Bilder/Screenshots";
            };
          };
        };
    };
}
