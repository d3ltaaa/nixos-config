{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    hardware.usb = {
      enable = lib.mkEnableOption "Enables udisks2";
    };
  };

  config =
    let
      cfg = config.hardware.usb;
    in
    lib.mkIf cfg.enable {
      services.udisks2.enable = true;
      services.udisks2.package = pkgs.udisks2;
      home-manager.users.${config.system.user.general.primary} =
        { ... }:
        {
          services.udiskie = {
            enable = true;
            settings = {
              program_options = {
                # replace with your favorite file manager
                file_manager = "${pkgs.nautilus}/bin/nautilus";
              };
            };
          };
        };
    };
}
