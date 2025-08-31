{ lib, config, ... }:
{
  options = {
    applications.configurations.client.virtualbox = {
      enable = lib.mkEnableOption "Enables virtualbox module";
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.virtualbox;
    in
    lib.mkIf cfg.enable {
      users.groups.vboxusers.members = [ "${config.system.user.general.primary}" ];

      virtualisation.virtualbox = {
        host = {
          enable = true;
          enableExtensionPack = false;
          addNetworkInterface = true;
          enableKvm = false;
        };
        guest = {
          enable = true;
          dragAndDrop = true;
          clipboard = true;
        };
      };
    };
}
