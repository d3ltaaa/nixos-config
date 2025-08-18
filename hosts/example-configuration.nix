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
        name = "T480";
        nixosStateVersion = "25.05";
        homeManagerStateVersion = "25.05";
      };
      locale = {
        language = "en";
        timeZone = "Europe/Berlin";
        keyboardLayout = "de";
      };
    };
    boot = {
      primaryBoot = true;
      osProber = false;
      defaultEntry = 0;
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
      '';
    };
    destkop = {
      hyprland-desktop = {
        hyprland = {
          enable = true;
          monitor = [
            "DP-3, 2560x1440@240, 0x0, 1"
            "DP-2, 1920x1080@165, 2560x0, 1"
          ];
          workspaces = [
            "1, monitor:DP-3"
            "3, monitor:DP-3"
            "5, monitor:DP-3"
            "7, monitor:DP-3"
            "9, monitor:DP-3"
            "2, monitor:DP-2"
            "4, monitor:DP-2"
            "6, monitor:DP-2"
            "8, monitor:DP-2"
          ];
        };
        hypridle = { };
        hyprlock = { };
        waybar = { };
        rofi = { };
        swappy = { };
        swww = { };
        cliphist = { };
        dunst = { };
        dconf = { };
        nwg-dock = { };
        settings = {
          nwg-displays = { };
        };
      };
      theme = { };
      session = {
        autoLogin = {
          enable = true;
        };
        autoShutdown = {
          enable = false;
          watchPort = "${config.services.ollama.port}";
          shutdownTime = "1800"; # seconds
        };
      };
    };
    security = {
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
      };
    };
    networking = {
      general = {
        lanInterface = "enp0s31f6";
        wifiInterface = "wlp3s0";
        staticIp = null;
        defaultGateway = null;
        nameservers = [ "1.1.1.1" ];
      };
      firewall = { };
      bridgedNetwork = { };
      wakeOnLan = { };
      server = {
        vpn = {
          wireguard = {
            client = {
              enable = true;
              address = [ "10.100.0.2/32" ];
              dns = [
                "192.168.2.11"
                "192.168.2.1"
              ];
              serverPublicKey = "hAvazVD4FMIbtZPLa5rtUXrZ3iXYIiW5Ivemyv1UmWA=";
            };
            server = {
              enable = false;
              serverPeers = [
                {
                  # T480
                  publicKey = "fSaTvwFYNcAx/dKxS9HCEB/017HITk/dpZCwJ1uZDDs=";
                  allowedIPs = [ "10.100.0.2/32" ];
                }
                {
                  # PHONE
                  publicKey = "Am+PSLEvczLPxaoI/x2QEiQCe1N5/LwSzVqPD/CUDF4=";
                  allowedIPs = [ "10.100.0.3/32" ];
                }
                {
                  # TABS9
                  publicKey = "Ggovi9VYVEHK70enoT/8/GweGBTX8xgiktRTMSGboww=";
                  allowedIPs = [ "10.100.0.4/32" ];
                }
              ];
            };
          };
        };
        dnsmasq = {
          enable = false;
          address = [
            "/${config.secrets.serverAddress}/192.168.2.11"
          ];
        };
        acme = {
          enable = true;
          domain = "${config.secrets.serverAddress}";
          email = "${config.secrets.acmeEmail}";
          dnsProvider = "ipv64";
          domainNames = [
            "dp.${config.secrets.serverAddress}"
            "proxmox.${config.secrets.serverAddress}"
            "vault.${config.secrets.serverAddress}"
            "home.${config.secrets.serverAddress}"
            "wg.${config.secrets.serverAddress}"
            "homeassistant.${config.secrets.serverAddress}"
            "ollama.${config.secrets.serverAddress}"
            "syncthing.${config.secrets.serverAddress}"
          ];
        };
        nginx = {
          enable = false;
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
        };
      };
    };
    user = {
      general = {
        primary = "falk";
      };
      directories = { };
    };
  };
  hardware = {
    drawingTablet = {
      enable = true;
    };
    bluetooth = {
      enable = true;
    };
    audio = {
      enable = true;
    };
    amdGpu = {
      enable = true;
    };
    nvidiaGpu = {
      enable = true;
      enableGpu = false;
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:0@01:0:0";
    };
    printing = {
      enable = true;
      printer.ML-1865W.enable = true;
      installDriver = {
        general = true;
        hp = true;
        samsung = true;
      };
    };
    brightness = {
      enable = true;
      monitorType = "internal";
    };
    powerManagement = {
      upower.enable = true;
      tlp.enable = true;
      auto-cpufreq = {
        enable = true;
        thresholds = true;
      };
    };
    usb = {
      enable = true;
    };
    partitioning = {
      enable = true;
    };
  };
  applications = {
    configurations = {
      server = {
        grafana = {
          enable = true;
        };
        jellyfin = {
          enable = true;
        };
        n8n = {
          enable = true;
        };
        ntfy = {
          enable = true;
          base-url = "https://ntfy.${config.secrets.serverAddress}";
        };
        litellm = {
          enable = true;
        };
        radicale = {
          enable = true;
        };
        homepage = {
          enable = true;
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
                    href = "https://proxmox.${config.settings.general.serverAddress}";
                  };
                }
                {
                  "Wireguard" = {
                    icon = "wireguard.png";
                    href = "https://wg.${config.settings.general.serverAddress}";
                  };
                }
                {
                  "Ntfy" = {
                    icon = "ntfy.png";
                    href = "https://ntfy.${config.settings.general.serverAddress}";
                  };
                }
                {
                  "Litellm" = {
                    icon = "anything-llm-light.png";
                    href = "https://litellm.${config.settings.general.serverAddress}";
                  };
                }
                {
                  "Radicale" = {
                    icon = "radicale.png";
                    href = "https://radicale.${config.settings.general.serverAddress}";
                  };
                }
              ];
            }
            {
              "Services" = [
                {
                  "Syncthing" = {
                    icon = "syncthing.png";
                    href = "https://syncthing.${config.settings.general.serverAddress}";
                  };
                }
                {
                  "n8n" = {
                    icon = "n8n.png";
                    href = "https://n8n.${config.settings.general.serverAddress}";
                  };
                }
                {
                  "Vaultwarden" = {
                    icon = "vaultwarden.png";
                    href = "https://vault.${config.settings.general.serverAddress}";
                  };
                }
                {
                  "Homeassistant" = {
                    icon = "home-assistant.png";
                    href = "https://homeassistant.${config.settings.general.serverAddress}";
                  };
                }
                {
                  "Open-Webui" = {
                    icon = "open-webui.png";
                    href = "https://open-webui.${config.settings.general.serverAddress}";
                  };
                }
                {
                  "Jellyfin" = {
                    icon = "jellyfin.png";
                    href = "https://jf.${config.settings.general.serverAddress}";
                  };
                }
                {
                  "Grafana" = {
                    icon = "grafana.png";
                    href = "https://grafana.${config.settings.general.serverAddress}";
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
                    href = "https://dp.${config.settings.general.serverAddress}";
                  };
                }
              ];
            }
          ];
        };
        ollama = {
          enable = true;
          dualSetup = true;
          modelDir = "/mnt/share/ollama/models";
          homeDir = "/mnt/share/ollama/home";
        };
        fileSharing = {
          enable = true;
          ip = "192.168.2.12";
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
          ];
        };
        syncthing = {
          enable = true;
          devices = {
            "PC".id = "MIR6FXD-EEKYM5S-GQFPDZT-DWNCTYW-XGZNIGY-6CNO5C2-VOR6YPG-T3JCMAX";
            "PX8".id = "UPROPYX-AFK4Q5X-P5WRKRE-4VXJ5XU-QKTXML3-2SFWBV7-ELVVPDH-AOWS2QY";
            # "T480".id = "Z3EA4H3-RNVAKPJ-JIWF4HD-L4AISEX-DUZZ4SV-P3E45GU-AKA3DHG-VYQNRAK";
            "T440P".id = "CAWY2HI-K3QLENX-QABH4C4-QDGBZAB-GH22BRL-ZB6YBG5-PXVDZTR-4MSF7QY";
            "SERVER".id = "OP5RCKE-UFEQ4IT-DRMANC2-425AFHE-RS4PG3Y-35VLH6F-7UJXUIJ-EAVK5A3";
          };

          folders = {
            "Dokumente" = {
              path = "/home/${config.settings.users.primary}/Dokumente";
              devices = [
                "PC"
                # "T480"
                "T440P"
                "SERVER"
              ];
            };
            "Bilder" = {
              path = "/home/${config.settings.users.primary}/Bilder";
              devices = [
                "PC"
                # "T480"
                "T440P"
                "SERVER"
              ];
            };
          };
        };
        vaultwarden = {
          enable = true;
        };
        homeassistant = {
          enable = true;
        };
      };
      client = {
        fileSharing = {
          enable = true;
          items = [
            {
              share = {
                "/mnt/private" = {
                  device = "//192.168.2.12/private";
                };
              };
            }
          ];
        };
        virtualbox = {
          enable = true;
        };
        qemu = {
          enable = true;
        };
        ssh = {
          enable = true;
        };
        timeshift = {
          enable = true;
        };
        protonmail = {
          enable = true;
        };
        thunderbird = {
          enable = true;
        };
        thunar = {
          enable = true;
        };
        spotify = {
          enable = true;
        };
        open-webui = {
          enable = true;
        };
        firefox = {
          enable = true;
        };
        foot = {
          enable = true;
        };
        lf = {
          enable = true;
        };
        tmux = {
          enable = true;
        };
        zsh = {
          enable = true;
        };
        neovim = {
          enable = true;
        };
        git = {
          enable = true;
          username = config.secrets.githubUsername;
          email = config.secrets.githubEmail;
        };
      };
    };
    packages = {
      nixpkgs = { };
      flatpaks = { };
      derivations = { };
      derivations = {
        fscripts = { };
      };
    };
  };
}
