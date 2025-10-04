{
  lib,
  config,
  nixpkgs-stable,
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
      services.fwupd.package = nixpkgs-stable.fwupd;
      services.fprintd.enable = true;
      services.fprintd.package =
        if config.services.fprintd.tod.enable then nixpkgs-stable.fprintd-tod else nixpkgs-stable.fprintd;
      services.fprintd.tod.enable = true;
      services.fprintd.tod.driver = nixpkgs-stable.libfprint-2-tod1-goodix;

      security.pam = {
        package = nixpkgs-stable.pam;
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
