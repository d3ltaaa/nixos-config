{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configurations.client.fileSharing = {
      enable = lib.mkEnableOption "Enables fileSharing-client module";
      items = lib.mkOption {
        type =
          with lib.types;
          listOf (submodule {
            options = {
              share = lib.mkOption {
                type = attrsOf (types.attrs);
                description = "One Samba share definition.";
              };
            };
          });
        default = [ ];
        description = "List of Samba share definitions.";
      };
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.fileSharing;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [
        pkgs.cifs-utils
        pkgs.samba
      ];

      fileSystems =
        let
          defaultOptions = {
            fsType = "cifs";
            options =
              let
                # this line prevents hanging on network split
                automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,cache=none,x-systemd.mount-timeout=5s,user,users";
              in
              [ "${automount_opts},credentials=/etc/samba/smb-secrets,uid=1000,gid=100" ];
          };

          generateFileSystems =
            item:
            let
              name = builtins.head (builtins.attrNames item.share);
              userConfig = item.share.${name};
              fullConfig = lib.recursiveUpdate defaultOptions userConfig;
            in
            {
              ${name} = fullConfig;
            };
        in
        lib.mkMerge ([ ] ++ map generateFileSystems cfg.items);
    };
}
