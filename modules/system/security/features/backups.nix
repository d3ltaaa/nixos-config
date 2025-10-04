{
  lib,
  config,
  nixpkgs-stable,
  ...
}:
{
  options = {
    system.security.features.backups = {
      enable = lib.mkEnableOption "Enables borg backup + frontend";
    };
  };

  config =
    let
      cfg = config.system.security.features.backups;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = with nixpkgs-stable; [
        deja-dup
        # vorta
      ];
    };
}
