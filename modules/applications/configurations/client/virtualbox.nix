{
  lib,
  config,
  pkgs,
  ...
}:
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

      boot.blacklistedKernelModules = [ "kvm-amd" ];
      virtualisation.virtualbox = {
        host = {
          enable = true;
          package = pkgs.virtualbox;
          enableExtensionPack = false;
          addNetworkInterface = true;
          enableKvm = false;
        };
        guest = {
          enable = false;
          dragAndDrop = false;
          clipboard = false;
        };
      };
    };
}
