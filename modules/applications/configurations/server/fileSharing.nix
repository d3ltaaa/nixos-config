{ lib, config, ... }:
{
  options = {
    applications.configurations.server.fileSharing = {
      enable = lib.mkEnableOption "Enables fileSharing module";
      ip = lib.mkOption {
        type = lib.types.str;
      };
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
      cfg = config.applications.configurations.server.fileSharing;
    in
    lib.mkIf cfg.enable {
      networking = {
        useDHCP = false;
        interfaces.ens18.ipv4.addresses = [
          {
            address = cfg.ip;
            prefixLength = 24;
          }
        ];
        defaultGateway = config.settings.networking.defaultGateway;
        nameservers = [
          config.settings.networking.defaultGateway
        ]; # or your router's DNS
      };
      services.samba-wsdd = {
        enable = true;
        openFirewall = true;
      };
      services.samba = {
        enable = true;
        openFirewall = true;
        settings =
          let
            defaultShareOptions = {
              "create mask" = "0644";
              "directory mask" = "0755";
              "browseable" = "yes";
              "read only" = "no";
              "guest ok" = "no";
            };

            generateShare =
              item:
              let
                name = builtins.head (builtins.attrNames item.share);
                userConfig = item.share.${name};
                fullConfig = lib.recursiveUpdate defaultShareOptions userConfig;
              in
              {
                ${name} = fullConfig;
              };

          in
          lib.mkMerge (
            [
              {
                global = {
                  "workgroup" = "WORKGROUP";
                  "server string" = "nixos-smb";
                  "netbios name" = "nixos-smb";
                  "security" = "user";
                  "hosts allow" = "192.168.2. 127.0.0.1 localhost";
                  "hosts deny" = "0.0.0.0/0";
                  "guest account" = "nobody";
                  "map to guest" = "bad user";
                };
              }
            ]
            ++ map generateShare cfg.items
          );
      };
    };
}
