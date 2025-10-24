{
  lib,
  config,
  ...
}:
{
  # accessible for root at /etc/credentials
  imports = [
    ./hardware-configuration.nix
  ];
  secrets = {
    serverAddress = lib.strings.trim (builtins.readFile "/etc/credentials/server_address");
    mailHost = lib.strings.trim (builtins.readFile "/etc/credentials/mail/host");
    mailEmail = lib.strings.trim (builtins.readFile "/etc/credentials/mail/email");
    ipv64KeyFile = lib.strings.trim (builtins.readFile "/etc/credentials/acmeIPV64.cert");
    acmeEmail = lib.strings.trim (builtins.readFile "/etc/credentials/acmeEmail");
    githubUsername = lib.strings.trim (builtins.readFile "/etc/credentials/github/username");
    githubEmail = lib.strings.trim (builtins.readFile "/etc/credentials/github/email");
    monitoringEmail = lib.strings.trim (builtins.readFile "/etc/credentials/monitoring/email");
    privateWireguardKey = lib.strings.trim (
      builtins.readFile "/etc/credentials/wireguard-keys/private"
    );
  };

  system = {
    general = {
      nixos = {
        name = "VM0";
        nixosStateVersion = "25.05";
        homeManagerStateVersion = "25.05";
      };
      locale = {
        language = "en";
        timeZone = "Europe/Berlin";
        keyboardLayout = "de";
      };
    };
    user.general.primary = "falk";
    boot = {
      primaryBoot = true;
      bootloader = "limine";
      secureBoot = false;
      extraEntries = null;
    };
    desktop = {
      components.session = {
        autoLogin.enable = true;
      };
      environment = {
        enable = true;
      };
      theme.colorSchemes = null;
    };
    security = {
      monitoring = {
        OnBootSec = "5min";
        OnUnitActiveSec = "1h";
        services = [
          # {
          #   notify = "${config.secrets.monitoringEmail}";
          #   flag = 0;
          #   service = "syncthing.service";
          #   pattern = "error|warning|critical";
          #   title = "Syncthing service alert";
          #   timeframe = "1 day ago";
          # }
        ];
      };
      features = {
        gnupg.enable = true;
        polkit.enable = true;
        fail2ban.enable = true; # monitored
        clamav = {
          enable = true; # monitored
          interval = "*-*-* 17:00:00";
        };
      };
    };
    networking = {
      general = {
        lanInterface = "ens18";
        wifiInterface = null;
        staticIp = "192.168.2.11";
        defaultGateway = "192.168.2.1";
        nameservers = [
          "1.1.1.1"
        ];
      };
      bridgedNetwork.enable = true; # (for wireguard)
      acme = {
        enable = true;
        domain = config.secrets.serverAddress;
        email = config.secrets.acmeEmail;
        dnsProvider = "ipv64";
        domainNames = [
          "dp.${config.secrets.serverAddress}"
          "proxmox.${config.secrets.serverAddress}"
          "vault.${config.secrets.serverAddress}"
          "home.${config.secrets.serverAddress}"
          "wg.${config.secrets.serverAddress}"
          "homeassistant.${config.secrets.serverAddress}"
          "ntfy.${config.secrets.serverAddress}"
          "open-webui.${config.secrets.serverAddress}"
          "litellm.${config.secrets.serverAddress}"
          "syncthing.${config.secrets.serverAddress}"
          "n8n.${config.secrets.serverAddress}"
          "radicale.${config.secrets.serverAddress}"
          "jf.${config.secrets.serverAddress}"
          "grafana.${config.secrets.serverAddress}"
        ];
      };
      dnsmasq = {
        enable = true;
        address = [
          "/${config.secrets.serverAddress}/192.168.2.11"
        ];
      };
      nginx = {
        enable = true;
        virtualHosts = {
          "proxmox.${config.secrets.serverAddress}" = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "https://192.168.2.10:8006";
              proxyWebsockets = true;
              extraConfig = ''
                client_max_body_size 8G;
                proxy_buffering off;
                proxy_request_buffering off;
                proxy_connect_timeout 3600;
                proxy_send_timeout 3600;
                proxy_read_timeout 3600;
              '';
            };
          };
          "dp.${config.secrets.serverAddress}" = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://192.168.2.31:80"; # allow dp.${serverAddress} in moonraker manually
              proxyWebsockets = true;
            };
          };
          "vault.${config.secrets.serverAddress}" = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://192.168.2.12:8222";
              proxyWebsockets = true;
            };
          };
          "home.${config.secrets.serverAddress}" = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://192.168.2.12:8082";
              proxyWebsockets = true;
            };
          };
          "wg.${config.secrets.serverAddress}" = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://192.168.2.11:5000";
              proxyWebsockets = true;
            };
          };
          "homeassistant.${config.secrets.serverAddress}" = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://192.168.2.12:8123";
              proxyWebsockets = true;
            };
          };
          "ntfy.${config.secrets.serverAddress}" = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://192.168.2.12:8070";
              proxyWebsockets = true;
            };
          };
          "open-webui.${config.secrets.serverAddress}" = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://192.168.2.12:8080";
              proxyWebsockets = true;
            };
          };
          "litellm.${config.secrets.serverAddress}" = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://192.168.2.12:8090";
              proxyWebsockets = true;
            };
          };
          "syncthing.${config.secrets.serverAddress}" = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://192.168.2.12:8384";
              proxyWebsockets = true;
            };
          };
          "n8n.${config.secrets.serverAddress}" = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://192.168.2.12:5678";
              proxyWebsockets = true;
            };
          };
          "radicale.${config.secrets.serverAddress}" = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://192.168.2.12:5232";
              proxyWebsockets = true;
            };
          };
          "jf.${config.secrets.serverAddress}" = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://192.168.2.12:8096";
              proxyWebsockets = true;
            };
          };
          "grafana.${config.secrets.serverAddress}" = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://192.168.2.12:2342";
              proxyWebsockets = true;
              recommendedProxySettings = true;
            };
          };
        };
      };
      vpn = {
        wireguard = {
          server = [
            {
              name = "wg1";
              enable = true;
              ips = [ "10.100.0.1/24" ];
              subnet = "10.100.0.0/24";
              listenPort = 51920;
              privateKeyFile = "/etc/credentials/wireguard-keys/wg1/private";
              serverPeers = [
                {
                  # FW13
                  publicKey = "HmfK0Mlqu22xaIpvwf5CI+J5jvvJBt5q5hfTAHm4yHY=";
                  allowedIPs = [ "10.100.0.5/32" ];
                }
                {
                  # PHONE
                  publicKey = "Am+PSLEvczLPxaoI/x2QEiQCe1N5/LwSzVqPD/CUDF4=";
                  allowedIPs = [ "10.100.0.3/32" ];
                }
              ];
            }
            {
              # EU04lgKRk1yZAoPM+uwC+8thkxS1ycmtJVuaW8ZVKVc=
              name = "wg2";
              enable = true;
              ips = [ "10.200.0.1/24" ];
              subnet = "10.200.0.0/24";
              listenPort = 51930;
              privateKeyFile = "/etc/credentials/wireguard-keys/wg2/private";
              serverPeers = [
                {
                  # T14
                  publicKey = "UbMkKrSqVgxwdnkkeOwCz23H0/tcXaG17fceTwW2RgQ=";
                  allowedIPs = [ "10.200.0.6/32" ];
                }
              ];
            }
          ];
        };
      };
    };
  };
  hardware = { };
  applications = {
    configurations = {
      client = {
        ssh.enable = true;
        yazi.enable = true;
        tmux.enable = true;
        zsh.enable = true;
        neovim.nixvim.enable = true;
        git = {
          enable = true;
          username = config.secrets.githubUsername;
          email = config.secrets.githubEmail;
        };
      };
    };
    packages = {
      nixpkgs = {
        extraPackages = [ ];
        pkgs = {
          system = {
            default = true;
            base = true;
            tool = true;
          };
          user.default = true;
          font.default = true;
        };
        pkgs-alt = {
          system.default = true;
          user.default = true;
          font.default = true;
        };
      };
    };
  };
}
