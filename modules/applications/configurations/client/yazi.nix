{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configurations.client.yazi = {
      enable = lib.mkEnableOption "Enables Yazi module";
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.yazi;
    in
    lib.mkIf cfg.enable {
      home-manager.users.${config.system.user.general.primary} =
        { config, ... }:
        {

          programs.yazi = {
            enable = true;
            package = pkgs.yazi;
            plugins = {
              uiPlugin = pkgs.writeTextDir "init.lua" ''
                function Folder:icon(file) return ui.Span(" " .. file:icon() .. "  ") end
              '';
            };
            theme = {
              icon = {
                dirs = [
                  {
                    name = "**";
                    text = "󰉋";
                  }
                  {
                    name = "Desktop";
                    text = "";
                  }
                  {
                    name = "Dokumente";
                    text = "";
                  }
                  {
                    name = "Downloads";
                    text = "";
                  }
                  {
                    name = "Bilder";
                    text = "";
                  }
                  {
                    name = "Audio";
                    text = "";
                  }
                  {
                    name = "Movies";
                    text = "";
                  }
                  {
                    name = "Videos";
                    text = "";
                  }
                  {
                    name = "Public";
                    text = "";
                  }
                  {
                    name = "Library";
                    text = "";
                  }
                  {
                    name = "Code";
                    text = "";
                  }
                  {
                    name = ".config";
                    text = "";
                  }
                  {
                    name = "nixos-config";
                    text = "󱄅";
                  }
                ];
              };
            };
            settings = {
              mgr = {
                ratio = [
                  2
                  3
                  3
                ];
                sort_by = "natural";
                sort_sensitive = true;
                sort_reverse = false;
                sort_dir_first = true;
                linemode = "none";
                show_hidden = false;
                show_symlink = true;
              };

              preview = {
                image_filter = "lanczos3";
                image_quality = 90;
                tab_size = 1;
                max_width = 600;
                max_height = 900;
                cache_dir = "";
                ueberzug_scale = 1;
                ueberzug_offset = [
                  0
                  0
                  0
                  0
                ];
              };

              tasks = {
                micro_workers = 5;
                macro_workers = 10;
                bizarre_retry = 5;
              };

            };
          };
        };
    };
}
