{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.security.features.btrfs = {
      eneable = lib.mkEnableOption "Enables the btrfs monitoring service";
    };
  };

  config =
    let
      cfg = config.system.security.features.btrfs;
      btrfs-monitor-script = "${pkgs.writeShellScript "btrfs-monitor-script" ''
        ERRORS=$(btrfs device stats / | grep -v " 0" || true);
        if [[ "$ERRORS" == "" ]]; then
          echo "ERROR: $ERRORS"
        fi
      ''}";
    in
    lib.mkIf cfg.enable {
      systemd.user.units.btrfs-monitor = {
        description = "Enable thunar-daemon";
        after = [ "network.target" ];
        wantedBy = [ "default.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${btrfs-monitor-script}/bin/btrfs-monitor-script";
        };
      };
      environment.systemPackages = [ btrfs-monitor-script ];
    };
}
