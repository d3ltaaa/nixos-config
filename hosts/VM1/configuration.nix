{ lib, config, ... }:
{
  # accessible for root at /etc/credentials
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

  imports = [
    ./hardware-configuration.nix
  ];

  system = {
    general = {
      nixos = {
        name = "VM1"; # a
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
      bootloader = "limine";
      secureBoot = false;
      extraEntries = null; # a
    };
    desktop = {
      components.session = {
        autoLogin = {
          enable = true; # a
        };
      };
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
        lanInterface = "ens18"; # a
        wifiInterface = null; # a
        staticIp = "192.168.2.12"; # a
        defaultGateway = "192.168.2.1"; # a
        nameservers = [
          "192.168.2.11"
          "1.1.1.1"
        ]; # a
      };
    };
    user = {
      general = {
        primary = "falk"; # a
      };
    };
  };
  hardware = { };
  applications = {
    configurations = {
      server = {
        # grafana = {
        #   enable = true;
        # };
        jellyfin.enable = true; # a
        n8n.enable = false; # a
        litellm.enable = true; # a
        radicale.enable = true; # a
        vaultwarden.enable = true; # a
        homeassistant.enable = true; # a
        open-webui.enable = true;
        ntfy = {
          enable = true; # a
          base-url = "https://ntfy.${config.secrets.serverAddress}"; # a
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
      };
      client = {
        ssh.enable = true; # a
        yazi.enable = true;
        tmux.enable = true; # a
        zsh.enable = true; # a
        neovim = {
          nixvim.enable = true;
          nvf.enable = false;
        };
        git = {
          enable = true; # a
          username = config.secrets.githubUsername; # a
          email = config.secrets.githubEmail; # a
        };
        syncthing = {
          enable = true; # a
          gui = true;
          devices = {
            "PC".id = "MIR6FXD-EEKYM5S-GQFPDZT-DWNCTYW-XGZNIGY-6CNO5C2-VOR6YPG-T3JCMAX";
            "PX8".id = "UPROPYX-AFK4Q5X-P5WRKRE-4VXJ5XU-QKTXML3-2SFWBV7-ELVVPDH-AOWS2QY";
            "FW13".id = "N6F2GRB-VUPQC4F-DVNYES5-5KNJ36R-GGVAP2R-ZHHBV4U-UATR2JY-BRQ2NQ2";
            # "T480".id = "OHXDERI-SBNTM5Q-ZBM7UMC-BZUOLDB-U32FQZW-VNXGSH7-VKQTNJO-TM3VWAH";
            # "T440P".id = "CAWY2HI-K3QLENX-QABH4C4-QDGBZAB-GH22BRL-ZB6YBG5-PXVDZTR-4MSF7QY";
            # "SERVER".id = "OP5RCKE-UFEQ4IT-DRMANC2-425AFHE-RS4PG3Y-35VLH6F-                    7UJXUIJ-EAVK5A3";
          }; # a

          folders = {
            "Dokumente" = {
              path = "/mnt/syncthing/Dokumente";
              devices = [
                "PC"
                # "PX8"
                "FW13"
                # "T480"
                # "T440P"
                # "SERVER"
              ];
            }; # a
            "Bilder" = {
              path = "/mnt/syncthing/Bilder";
              devices = [
                "PC"
                # "PX8"
                "FW13"
                # "T480"
                # "T440P"
                # "SERVER"
              ];
            };
          }; # a
        };
      };
    };
    packages = {
      nixpkgs = {
        extraPackages = [ ]; # a
        pkgs = {
          system = {
            default = true; # a
            base = false; # a
            lang = false; # a
            tool = false; # a
            hypr = false; # a
            desk = false; # a
            power = false; # a
          };
          user.default = false; # a
          font.default = false; # a
        };
        pkgs-alt = {
          system.default = false; # a
          user.default = false; # a
          font.default = false; # a
        };
      };
      flatpaks = {
        enable = false; # a
      };
      derivations = {
        enable = false; # a
      };
    };
  };
}
