{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.networking.vpn.wireguard = {
      client = {
        enable = lib.mkEnableOption "Enables Wireguard-client module";
        address = lib.mkOption {
          type = lib.types.listOf (lib.types.str);
        };
        port = lib.mkOption {
          type = lib.types.int;
        };
        allowedIPs = lib.mkOption {
          type = lib.types.listOf lib.types.str;
        };
        dns = lib.mkOption {
          type = lib.types.listOf (lib.types.str);
        };
        serverPublicKey = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
      };
      server = lib.mkOption {
        default = [ ];
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              name = lib.mkOption {
                description = "The name of the interface";
                type = lib.types.str;
              };
              enable = lib.mkEnableOption "Enables specific VPN interface";
              ips = lib.mkOption {
                description = "Servers IP and subnet of tunnel interface";
                type = lib.types.listOf lib.types.str;
              };
              subnet = lib.mkOption {
                description = "Subnet of tunnel";
                type = lib.types.str;
              };
              listenPort = lib.mkOption {
                description = "Port on which to listen for clients";
                type = lib.types.int;
              };
              privateKeyFile = lib.mkOption {
                type = lib.types.path;
                description = "Path to the private key file";
              };
              serverPeers = lib.mkOption {
                type = lib.types.listOf (
                  lib.types.submodule {
                    options = {
                      publicKey = lib.mkOption {
                        type = lib.types.str;
                        description = "The public key of the peer.";
                      };

                      allowedIPs = lib.mkOption {
                        type = lib.types.listOf lib.types.str;
                        description = "List of allowed IPs for the peer.";
                      };
                    };
                  }
                );

                default = [ ];
                description = "List of WireGuard peers.";
              };
            };
          }
        );
      };
    };
  };

  config =
    let
      cfg = config.system.networking.vpn.wireguard;
    in
    lib.mkIf (cfg.client.enable || lib.any (wg: wg.enable) cfg.server) (
      lib.mkMerge [

        {
          networking = {
            wireguard.enable = true;
          };
        }

        (lib.mkIf cfg.client.enable {
          systemd.services.wg-quick-wg0 = {
            serviceConfig = {
              Restart = "on-failure";
              RestartSec = 5;
            };
          };

          networking = {
            wg-quick.interfaces.wg0 = {
              address = cfg.client.address;
              dns = cfg.client.dns;
              listenPort = null; # Don't listen for incoming connections (client-only)
              privateKeyFile = "/etc/credentials/wireguard-keys/private";
              peers = [
                {
                  publicKey = cfg.client.serverPublicKey;
                  endpoint = "${config.secrets.serverAddress}:${toString cfg.client.port}";
                  allowedIPs = cfg.client.allowedIPs;
                  persistentKeepalive = 25;
                }
              ];
            };
          };
        })
        # enable if one of server interfaces is enabled
        (lib.mkIf (lib.any (wg: wg.enable) cfg.server) {
          environment.systemPackages = with pkgs; [
            wireguard-tools
          ];

          # add every port to allowedUDPPorts
          networking.firewall.allowedUDPPorts = builtins.map (wg: wg.listenPort) (
            builtins.filter (wg: wg.enable) cfg.server
          );

          networking.wireguard.interfaces =
            let
              enabledServers = builtins.filter (wg: wg.enable) cfg.server;
            in
            lib.listToAttrs (
              map (cfg-attr: {
                name = cfg-attr.name;
                value = {
                  ips = cfg-attr.ips;
                  listenPort = cfg-attr.listenPort;
                  privateKeyFile = cfg-attr.privateKeyFile;
                  peers = cfg-attr.serverPeers;
                }
                // lib.optionalAttrs true {
                  postSetup = ''${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${cfg-attr.subnet} -o ${config.system.networking.general.lanInterface} -j MASQUERADE'';
                  postShutdown = ''${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${cfg-attr.subnet} -o ${config.system.networking.general.lanInterface} -j MASQUERADE'';
                };
              }) enabledServers
            );
        })
      ]
    );
}
