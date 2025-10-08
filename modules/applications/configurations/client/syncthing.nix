{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configurations.client.syncthing = {
      enable = lib.mkEnableOption "Enables Syncthing module";
      devices = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = { };
      };
      folders = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = { };
      };
      gui = lib.mkEnableOption "Enables gui access from outside";
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.syncthing;
    in
    lib.mkIf cfg.enable {
      networking.firewall.allowedTCPPorts = lib.mkIf cfg.gui [
        8384
      ];
      services.syncthing = {
        enable = true;
        # package = pkgs.syncthing;
        dataDir = "/home/${config.system.user.general.primary}";
        user = config.system.user.general.primary;
        openDefaultPorts = lib.mkIf cfg.gui true;
        guiAddress = lib.mkIf cfg.gui "0.0.0.0:8384";
        settings = {
          devices = cfg.devices;
          folders = cfg.folders;
        };
      };
      systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync
    };
}
