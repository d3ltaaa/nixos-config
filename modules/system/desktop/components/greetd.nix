{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.desktop.components.greetd = {
      enable = lib.mkEnableOption "Enables the greetd module";
    };
  };
  config =
    let
      cfg = config.system.desktop.components.greetd;
    in
    lib.mkIf cfg.enable {
      services.regreet.enable = true;
      # services.greetd = {
      #   enable = true;
      #   settings = {
      #     default_session = {
      #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet \
      #     --time --time-format '%I:%M %p | %a • %h | %F' \
      #     --cmd 'uwsm start hyprland'";
      #       user = "greeter";
      #     };
      #   };
      # };
    };
}
