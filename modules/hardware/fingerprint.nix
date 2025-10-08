{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    hardware.fingerprint = {
      enable = lib.mkEnableOption "Enables Fingerprint module";
      package = lib.mkOption {
        type = lib.types.pkgs;
        default = pkgs.libfprint-2-tod1-goodix;
      };
    };
  };

  config =
    let
      cfg = config.hardware.fingerprint;
    in
    lib.mkIf cfg.enable {
      services.fwupd.enable = true;
      services.fwupd.package = pkgs.fwupd;
      services.fprintd.enable = true;
      services.fprintd.package =
        if config.services.fprintd.tod.enable then pkgs.fprintd-tod else pkgs.fprintd;
      services.fprintd.tod.enable = true;
      services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

      security.pam = {
        package = pkgs.pam;
        services = {
          login = {
            fprintAuth = true;
          };
          polkit-1 = {
            fprintAuth = true;
          };
          sudo = {
            fprintAuth = true;
          };
        };
      };
    };
}
