{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.security.features.btrfs = {
      enable = lib.mkEnableOption "Enables the btrfs monitoring service";
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
      systemd.services.btrfs-monitor = {
        description = "Enable thunar-daemon";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${btrfs-monitor-script}/bin/btrfs-monitor-script";
        };
      };
      # environment.systemPackages = [ btrfs-monitor-script ];
    };
}
