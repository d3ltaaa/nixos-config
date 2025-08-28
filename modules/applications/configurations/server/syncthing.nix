{ lib, config, ... }:
{
  options = {
    applications.configurations.server.syncthing = {
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
      cfg = config.applications.configurations.server.syncthing;
    in
    lib.mkIf cfg.enable {
      networking.firewall.allowedTCPPorts = lib.mkIf cfg.gui [
        8384
      ];
      services.syncthing = {
        enable = true;
        dataDir = "/home/${config.settings.users.primary}";
        user = config.settings.users.primary;
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
