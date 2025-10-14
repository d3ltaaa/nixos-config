{ lib, config, ... }:
{
  # accessible for root at /etc/credentials
  secrets = {
    serverAddress = lib.strings.trim (builtins.readFile "/etc/credentials/server_address");
    ipv64KeyFile = lib.strings.trim (builtins.readFile "/etc/credentials/acmeIPV64.cert");
    acmeEmail = lib.strings.trim (builtins.readFile "/etc/credentials/acmeEmail");
    githubUserename = lib.strings.trim (builtins.readFile "/etc/credentials/github/username");
    githubEmail = lib.strings.trim (builtins.readFile "/etc/credentials/github/email");
    privateWireguardKey = lib.strings.trim (
      builtins.readFile "/etc/credentials/wireguard-keys/private"
    );
  };

  imports = [
    ./hardware-configuration.nix
  ];

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
      extraEntries = ''
        menuentry "NixOs (PC-SERVER)" {
            insmod part_gpt
            insmod fat
            search --no-floppy --label SERVER_BOOT --set=root
            chainloader /EFI/NixOS-boot/grubx64.efi
        }
        menuentry "Windows 10 " {
            insmod part_gpt
            insmod fat
            search --no-floppy --label W10_BOOT --set=root
            chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      ''; # a
    };
    destkop = {
      hyprland-desktop = {
        hyprland = {
          enable = true; # a
          # monitor = [
          #   "DP-3, 2560x1440@240, 0x0, 1"
          #   "DP-2, 1920x1080@165, 2560x0, 1"
          # ]; # a
          # workspaces = [
          #   "1, monitor:DP-3"
          #   "3, monitor:DP-3"
          #   "5, monitor:DP-3"
          #   "7, monitor:DP-3"
          #   "9, monitor:DP-3"
          #   "2, monitor:DP-2"
          #   "4, monitor:DP-2"
          #   "6, monitor:DP-2"
          #   "8, monitor:DP-2"
          # ]; # a
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
          enable = false; # a
        };
        satty = {
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
          watchPort = config.services.ollama.port; # a
          shutdownTime = "1800"; # seconds # a
        };
      };
    };
    security = {
      # TODO
      monitoring = { };
      features = {
        opensnitch = { };
        fail2ban = { };
        passwords = { };
        snapshots = { };
        backups = { };
        bleachBit = { };
        apparmor = { };
        firejail = { };
        clamav = { };
        gnupg = { };
      };
    };
    networking = {
      general = {
        lanInterface = "enp0s31f6"; # a
        wifiInterface = "wlp3s0"; # a
        staticIp = null; # a
        defaultGateway = null; # a
        nameservers = [ "1.1.1.1" ]; # a
      };
      firewall = { }; # a
      bridgedNetwork = {
        enable = true; # a (for wireguard)
      };
      wakeOnLan = {
        enable = true; # a
      };
      vpn = {
        wireguard = {
          client = {
            enable = true; # a
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
        enable = true; # a
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
      enable = true; # a
    };
    blueTooth = {
      enable = true; # a
    };
    audio = {
      enable = true; # a
    };
    amdGpu = {
      enable = true; # a
    };
    nvidiaGpu = {
      enable = true; # a
      enableGpu = false; # a
      intelBusId = "PCI:0@0:2:0"; # a
      nvidiaBusId = "PCI:0@01:0:0"; # a
    };
    printing = {
      enable = true; # a
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
      upower = {
        enable = true; # a
        criticalPowerHibernate = true;
      };
      tlp.enable = true; # a
      auto-cpufreq = {
        enable = true; # a
        thresholds = true; # a
      };
    };
    usb = {
      enable = true; # a
    };
    partitioning = {
      enable = true; # TODO
    };
  };
  applications = {
    configurations = {
      server = {
        # grafana = {
        #   enable = true;
        # };
        jellyfin = {
          enable = true; # a
        };
        n8n = {
          enable = true; # a
        };
        ntfy = {
          enable = true; # a
          base-url = "https://ntfy.${config.secrets.serverAddress}"; # a
        };
        litellm = {
          enable = true; # a
        };
        radicale = {
          enable = true; # a
        };
        homepage = {
          enable = true; # a
          widgets = [
            {
              resources = {
                cpu = true;
                disk = "/";
                memory = true;
              };
            }
            {
              search = {
                provider = "duckduckgo";
                target = "_blank";
              };
            }
          ];
          bookmarks = [
            {
              "Bookmarks" = [
                {
                  "Proton Mail" = [
                    {
                      icon = "proton-mail.png";
                      href = "https://mail.proton.me/u/0/inbox";
                    }
                  ];
                }
                {
                  "Proton Calendar" = [
                    {
                      icon = "proton-calendar.png";
                      href = "https://calendar.proton.me/u/0/";
                    }
                  ];
                }
                {
                  "Github" = [
                    {
                      icon = "github-light.png";
                      href = "https://github.com/";
                    }
                  ];
                }
                {
                  "Youtube" = [
                    {
                      icon = "youtube.png";
                      href = "https://youtube.com/";
                    }
                  ];
                }
                {
                  "ChatGPT" = [
                    {
                      icon = "chatgpt.png";
                      href = "https://chat.openai.com/chat";
                    }
                  ];
                }
                {
                  "HM4Mint" = [
                    {
                      icon = "bookstack.png";
                      href = "https://hm4mint.nrw/hm1/link/HoeherMathem1";
                    }
                  ];
                }
              ];
            }
          ];
          services = [
            {
              "Administration" = [
                {
                  "Proxmox" = {
                    icon = "proxmox.png";
                    href = "https://proxmox.${config.secrets.serverAddress}";
                  };
                }
                {
                  "Wireguard" = {
                    icon = "wireguard.png";
                    href = "https://wg.${config.secrets.serverAddress}";
                  };
                }
                {
                  "Ntfy" = {
                    icon = "ntfy.png";
                    href = "https://ntfy.${config.secrets.serverAddress}";
                  };
                }
                {
                  "Litellm" = {
                    icon = "anything-llm-light.png";
                    href = "https://litellm.${config.secrets.serverAddress}";
                  };
                }
                {
                  "Radicale" = {
                    icon = "radicale.png";
                    href = "https://radicale.${config.secrets.serverAddress}";
                  };
                }
              ];
            }
            {
              "Services" = [
                {
                  "Syncthing" = {
                    icon = "syncthing.png";
                    href = "https://syncthing.${config.secrets.serverAddress}";
                  };
                }
                {
                  "n8n" = {
                    icon = "n8n.png";
                    href = "https://n8n.${config.secrets.serverAddress}";
                  };
                }
                {
                  "Vaultwarden" = {
                    icon = "vaultwarden.png";
                    href = "https://vault.${config.secrets.serverAddress}";
                  };
                }
                {
                  "Homeassistant" = {
                    icon = "home-assistant.png";
                    href = "https://homeassistant.${config.secrets.serverAddress}";
                  };
                }
                {
                  "Open-Webui" = {
                    icon = "open-webui.png";
                    href = "https://open-webui.${config.secrets.serverAddress}";
                  };
                }
                {
                  "Jellyfin" = {
                    icon = "jellyfin.png";
                    href = "https://jf.${config.secrets.serverAddress}";
                  };
                }
                {
                  "Grafana" = {
                    icon = "grafana.png";
                    href = "https://grafana.${config.secrets.serverAddress}";
                  };
                }
              ];
            }
            {
              "Devices" = [
                {
                  "Router" = {
                    icon = "router.png";
                    href = "http://192.168.2.1";
                  };
                }
                {
                  "3D Printer" = {
                    icon = "mainsail.png";
                    href = "https://dp.${config.secrets.serverAddress}";
                  };
                }
              ];
            }
          ]; # a
        };
        ollama = {
          enable = true; # a
          dualSetup = true; # a
          modelDir = "/mnt/share/ollama/models"; # a
          homeDir = "/mnt/share/ollama/home"; # a
        };
        fileSharing = {
          enable = true; # a
          ip = "192.168.2.12"; # a
          items = [
            {
              share = {
                private = {
                  path = "/mnt/shared/private";
                  "force user" = "falk";
                  "force group" = "users";
                };
              };
            }
            {
              share = {
                public = {
                  path = "/mnt/shared/public";
                  "guest ok" = "yes";
                  "public" = "yes";
                  "force user" = "nobody";
                  "force group" = "nobody";
                  "read only" = "no";
                  "create mask" = "0777";
                  "directory mask" = "0777";
                };
              };
            }
          ]; # a
        };
        syncthing = {
          enable = true; # a
          devices = {
            "PC".id = "MIR6FXD-EEKYM5S-GQFPDZT-DWNCTYW-XGZNIGY-6CNO5C2-VOR6YPG-T3JCMAX";
            "PX8".id = "UPROPYX-AFK4Q5X-P5WRKRE-4VXJ5XU-QKTXML3-2SFWBV7-ELVVPDH-AOWS2QY";
            # "T480".id = "Z3EA4H3-RNVAKPJ-JIWF4HD-L4AISEX-DUZZ4SV-P3E45GU-AKA3DHG-VYQNRAK";
            "T440P".id = "CAWY2HI-K3QLENX-QABH4C4-QDGBZAB-GH22BRL-ZB6YBG5-PXVDZTR-4MSF7QY";
            "SERVER".id = "OP5RCKE-UFEQ4IT-DRMANC2-425AFHE-RS4PG3Y-35VLH6F-7UJXUIJ-EAVK5A3";
          }; # a

          folders = {
            "Dokumente" = {
              path = "/home/${config.system.user.general.primary}/Dokumente";
              devices = [
                "PC"
                # "T480"
                "T440P"
                "SERVER"
              ];
            }; # a
            "Bilder" = {
              path = "/home/${config.system.user.general.primary}/Bilder";
              devices = [
                "PC"
                # "T480"
                "T440P"
                "SERVER"
              ];
            };
          }; # a
        };
        vaultwarden = {
          enable = true; # a
        };
        homeassistant = {
          enable = true; # a
        };
      };
      client = {
        fileSharing = {
          enable = true; # a
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
          enable = true; # a
        };
        qemu = {
          enable = true; # a
        };
        ssh = {
          enable = true; # a
        };
        protonmail = {
          enable = true; # a
        };
        thunderbird = {
          enable = true; # a
        };
        thunar = {
          enable = true; # a
        };
        spotify = {
          enable = true; # a
        };
        firefox = {
          enable = false; # a
        };
        brave = {
          enable = true;
        };
        localsend = {
          enable = true;
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
