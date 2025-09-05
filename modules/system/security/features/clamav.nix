{ lib, config, ... }:
{
  options = {
    system.security.features.clamav = {
      enable = lib.mkEnableOption "Enable Clam-Anti-Virus";
      interval = lib.mkOption {
        type = lib.types.str;
        default = "*-*-* 17:00:00";
      };
    };
  };

  config =
    let
      cfg = config.system.security.features.clamav;
    in
    lib.mkIf cfg.enable {
      system.security.monitoring.services = [
        {
          notify = "${config.secrets.monitoringEmail}";
          flag = 0;
          service = "clamav-daemon.service";
          pattern = "error|found";
          title = "Clamav service alert";
          timeframe = "1 day ago";
        }
      ];

      services.clamav = {
        settings = {
          ExcludePath = "^/hom/falk/.local/share/containers";
        };
      };
      scanner = {
        enable = true;
        interval = cfg.interval;
      };
      updater.enable = true;
    };
}
