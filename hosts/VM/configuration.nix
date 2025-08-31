{ lib, config, ... }:
{
  # accessible for root at /etc/credentials
  imports = [
    ./hardware-configuration.nix
  ];
  secrets = {
    serverAddress = lib.strings.trim (builtins.readFile "/etc/credentials/server_address");
    ipv64KeyFile = lib.strings.trim (builtins.readFile "/etc/credentials/acmeIPV64.cert");
    acmeEmail = lib.strings.trim (builtins.readFile "/etc/credentials/acmeEmail");
    githubUsername = lib.strings.trim (builtins.readFile "/etc/credentials/github/username");
    githubEmail = lib.strings.trim (builtins.readFile "/etc/credentials/github/email");
    privateWireguardKey = lib.strings.trim (
      builtins.readFile "/etc/credentials/wireguard-keys/private"
    );
  };

  system = {
    general = {
      nixos = {
        name = "T480"; # a
        nixosStateVersion = "25.05"; # a
        homeManagerStateVersion = "25.05"; # a
      };
      locale = {
        language = "en"; # a
        timeZone = "Europe/Berlin"; # a
        keyboardLayout = "de"; # a
      };
    };
    boot = {
      primaryBoot = true; # a
      osProber = false; # a
      defaultEntry = 0; # a
      extraEntries = null; # a
    };
    desktop = {
      hyprland-desktop = {
        hyprland = {
          enable = true; # a
        };
        hypridle = {
          enable = true; # a
        };
        hyprlock = {
          enable = true; # a
        };
        waybar = {
          enable = true; # a
        };
        rofi = {
          enable = true; # a
        };
        swappy = {
          enable = true; # a
        };
        swww = {
          enable = true; # a
        };
        cliphist = {
          enable = true; # a
        };
        dunst = {
          enable = true; # a
        };
        dconf = {
          enable = true; # a
        };
        nwg-dock = {
          enable = true; # TODO
        };
        settings = {
          nwg-displays = {
            enable = true; # a
          };
        };
      };
      theme = {
        colorSchemes = null; # a
        gtk = {
          enable = true; # a
          theme.name = "Adwaita"; # a
          theme.package = null; # a
          cursor.name = "Bibata-Modern-Ice"; # a
          cursor.package = null; # a
          icon.name = "WhiteSur-light"; # a
          icon.package = "whitesur-icon-theme"; # a
        };
        qt = {
          enable = true; # a
          theme.name = "adwaita"; # a
          theme.package = null; # a
          style.name = "adwaita-light"; # a
          style.package = null; # a
        };
      };
      session = {
        autoLogin = {
          enable = true; # a
        };
        autoShutdown = {
          enable = false; # a
          watchPort = toString config.services.ollama.port; # a
          shutdownTime = "1800"; # seconds # a
        };
      };
    };
    # security = {
    #   # TODO
    #   monitoring = { };
    #   features = {
    #     opensnitch = { };
    #     fail2ban = { };
    #     passwords = { };
    #     snapshots = { };
    #     backups = { };
    #     bleachBit = { };
    #     apparmor = { };
    #     firejail = { };
    #     clamav = { };
    #     gnupg = { };
    #   };
    # };
    networking = {
      general = {
        lanInterface = "enp0s31f6"; # a
        wifiInterface = "wlp3s0"; # a
        staticIp = null; # a
        defaultGateway = null; # a
        nameservers = [ "1.1.1.1" ]; # a
      };
      # firewall = { }; # a
      bridgedNetwork = {
        enable = true; # a (for wireguard)
      };
      wakeOnLan = {
        enable = true; # a
      };
      vpn = {
        wireguard = {
          client = {
            enable = false; # a
            address = [ "10.100.0.2/32" ]; # a
            dns = [
              "192.168.2.11"
              "192.168.2.1"
            ]; # a
            serverPublicKey = "hAvazVD4FMIbtZPLa5rtUXrZ3iXYIiW5Ivemyv1UmWA="; # a
          };
          server = {
            enable = false; # a
            serverPeers = [
              {
                # T480
                publicKey = "fSaTvwFYNcAx/dKxS9HCEB/017HITk/dpZCwJ1uZDDs="; # a
                allowedIPs = [ "10.100.0.2/32" ]; # a
              }
              {
                # PHONE
                publicKey = "Am+PSLEvczLPxaoI/x2QEiQCe1N5/LwSzVqPD/CUDF4="; # a
                allowedIPs = [ "10.100.0.3/32" ]; # a
              }
              {
                # TABS9
                publicKey = "Ggovi9VYVEHK70enoT/8/GweGBTX8xgiktRTMSGboww="; # a
                allowedIPs = [ "10.100.0.4/32" ]; # a
              }
            ];
          };
        };
      };
      dnsmasq = {
        enable = false; # a
        address = [
          "/${config.secrets.serverAddress}/192.168.2.11"
        ]; # a
      };
      acme = {
        enable = false; # a
        domain = "${config.secrets.serverAddress}"; # a
        email = "${config.secrets.acmeEmail}"; # a
        dnsProvider = "ipv64"; # a
        domainNames = [
          "dp.${config.secrets.serverAddress}"
          "proxmox.${config.secrets.serverAddress}"
          "vault.${config.secrets.serverAddress}"
          "home.${config.secrets.serverAddress}"
          "wg.${config.secrets.serverAddress}"
          "homeassistant.${config.secrets.serverAddress}"
          "ollama.${config.secrets.serverAddress}"
          "syncthing.${config.secrets.serverAddress}"
        ]; # a
      };
      nginx = {
        enable = false; # a
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
          "ollama.${config.secrets.serverAddress}" = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://192.168.2.12:8080";
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
        };
      }; # a
    };
    user = {
      general = {
        primary = "falk"; # a
      };
      directories = {
        enable = true; # a
      };
    };
  };
  hardware = {
    drawingTablet = {
      enable = false; # a
    };
    blueTooth = {
      enable = false; # a
    };
    audio = {
      enable = false; # a
    };
    amdGpu = {
      enable = false; # a
    };
    nvidiaGpu = {
      enable = false; # a
      enableGpu = false; # a
      intelBusId = "PCI:0@0:2:0"; # a
      nvidiaBusId = "PCI:0@01:0:0"; # a
    };
    printing = {
      enable = false; # a
      printer.ML-1865W.enable = true; # a
      installDriver = {
        general = true; # a
        hp = true; # a
        samsung = true; # a
      };
    };
    brightness = {
      enable = true; # a
      monitorType = "internal"; # a
    };
    powerManagement = {
      upower.enable = false; # a
      tlp.enable = false; # a
      auto-cpufreq = {
        enable = false; # a
        thresholds = true; # a
      };
    };
    usb = {
      enable = true; # a
    };
    # partitioning = {
    # enable = true; # TODO
    # };
  };
  applications = {
    configurations = {
      server = {
      };
      client = {
        fileSharing = {
          enable = false; # a
          items = [
            {
              share = {
                "/mnt/private" = {
                  device = "//192.168.2.12/private";
                };
              };
            }
          ]; # a
        };
        virtualbox = {
          enable = false; # a
        };
        qemu = {
          enable = false; # a
        };
        ssh = {
          enable = true; # a
        };
        thunar = {
          enable = true; # a
        };
        spotify = {
          enable = true; # a
        };
        firefox = {
          enable = true; # a
        };
        foot = {
          enable = true; # a
        };
        lf = {
          enable = true; # a
        };
        tmux = {
          enable = true; # a
        };
        zsh = {
          enable = true; # a
        };
        neovim = {
          enable = true;
        };
        git = {
          enable = true; # a
          # username = config.system.user.general.primary; # a
          username = config.secrets.githubUsername; # a
          email = config.secrets.githubEmail; # a
        };
      };
    };
    packages = {
      nixpkgs = {
        extraPackages = [ ]; # a
        stable = {
          system = {
            default = true; # a
            base = true; # a
            lang = true; # a
            tool = true; # a
            hypr = true; # a
            desk = true; # a
            power = true; # a
          };
          user.default = true; # a
          font.default = true; # a
        };
        unstable = {
          system.default = true; # a
          user.default = true; # a
          font.default = true; # a
        };
      };
      flatpaks = {
        enable = true; # a
      };
      derivations = {
        enable = true; # a
      };
    };
  };
}
