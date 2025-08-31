{ lib, config, ... }:
{
  options = {
    applications.configurations.client.foot = {
      enable = lib.mkEnableOption "Enables Foot module";
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.foot;
    in
    lib.mkIf cfg.enable {
      # Home Manager as NixOS module
      home-manager.users.${config.system.user.general.primary} =
        { config, ... }:
        {
          programs.foot =
            let
              palette = config.colorScheme.palette;
            in
            {
              enable = true;
              settings = {
                main = {
                  term = "xterm-256color";
                  font = "UbuntuMonoNerdFont:size=12";
                  font-bold = "UbuntuMonoNerdFont:size=12";
                  font-italic = "UbuntuMonoNerdFont:size=12";
                  font-bold-italic = "UbuntuMonoNerdFont:size=12";
                  pad = "2x2"; # 5x5
                };
                cursor = {
                  color = "${palette.base01} ${palette.base0F}";
                };
                colors = {
                  alpha = "0.8";

                  foreground = "${palette.base05}";
                  background = "${palette.base01}";

                  regular0 = "${palette.base04}";
                  regular1 = "${palette.base08}";
                  regular2 = "${palette.base0B}";
                  regular3 = "${palette.base0A}";
                  regular4 = "${palette.base0D}";
                  regular5 = "${palette.base0E}";
                  regular6 = "${palette.base0C}";
                  regular7 = "${palette.base05}";

                  bright0 = "${palette.base04}";
                  bright1 = "${palette.base08}";
                  bright2 = "${palette.base0B}";
                  bright3 = "${palette.base0A}";
                  bright4 = "${palette.base0D}";
                  bright5 = "${palette.base0E}";
                  bright6 = "${palette.base0C}";
                  bright7 = "${palette.base05}";

                  "16" = "${palette.base09}";
                  "17" = "${palette.base0F}";

                  selection-foreground = "${palette.base05}";
                  selection-background = "${palette.base02}";

                  search-box-no-match = "${palette.base01} ${palette.base08}";
                  search-box-match = "${palette.base05} ${palette.base03}";

                  jump-labels = "${palette.base01} ${palette.base09}";
                  urls = "${palette.base0D}";
                };
              };
            };
        };
    };
}
