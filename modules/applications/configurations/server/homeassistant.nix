{ lib, config, ... }:
{
  options = {
    applications.configurations.server.homeassistant = {
      enable = lib.mkEnableOption "Enables Homeassistant module";
    };
  };

  config =
    let
      cfg = config.applications.configurations.server.homeassistant;
    in
    lib.mkIf cfg.enable {
      networking.firewall.allowedUDPPorts = [ 8123 ];
      networking.firewall.allowedTCPPorts = [ 8123 ];
      virtualisation = {
        podman.enable = true;
        oci-containers = {
          containers = {
            homeassistant = {
              image = "homeassistant/home-assistant:stable";
              autoStart = true;
              extraOptions = [
                "--network=host"
                "--pull=newer"
              ];
              volumes = [
                "/var/lib/homeassistant:/config"
              ];
              environment = {
                TZ = config.settings.general.timeZone;
                PUID = toString config.users.users.${config.settings.users.primary}.uid;
                PGID = toString config.users.groups.users.gid;
              };
            };
          };
        };
      };
    };
}
