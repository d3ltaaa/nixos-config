{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.networking.wakeOnLan.enable = lib.mkEnableOption "Enables wake on lan";
  };

  config =
    let
      cfg = config.system.networking.wakeOnLan;
    in
    lib.mkIf cfg.enable {
      systemd.services.wakeonlan = lib.mkIf cfg.enable {
        description = "Re-enable Wake-on-LAN every boot";
        after = [ "network.target" ];
        wantedBy = [ "default.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.ethtool}/sbin/ethtool -s ${config.system.networking.general.lanInterface} wol g";
        };
      };
    };
}
