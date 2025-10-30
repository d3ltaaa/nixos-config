{
  lib,
  config,
  pkgs,
  ...
}:
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
        defaultGateway = config.system.networking.general.defaultGateway;
        nameservers = [
          config.system.networking.general.defaultGateway
        ]; # or your router's DNS
      };
      services.samba-wsdd = {
        enable = true;
        openFirewall = true;
      };

      users.users =
        let
          # collect all force user names (may be multiple shares per item!)
          allForceUsers = builtins.concatMap (
            item:
            builtins.concatMap (
              shareName:
              let
                s = item.share.${shareName};
              in
              lib.optional (s ? "force user") s."force user"
            ) (builtins.attrNames item.share)
          ) cfg.items;
          uniqueForceUsers = lib.unique allForceUsers;
        in
        builtins.listToAttrs (
          map (username: {
            name = username;
            value = lib.mkDefault {
              isSystemUser = true;
              home = "/var/empty";
              shell = "${pkgs.shadow}/bin/nologin";
              group = "users";
            };
          }) uniqueForceUsers
        );

      services.samba = {
        enable = true;
        package = pkgs.samba;
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
                  "preferred master" = "yes";
                  "os level" = "100";
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
