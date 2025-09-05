{ lib, config, ... }:
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
        name = "FW13"; # a
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
        hyprpolkitagent = {
          enable = true;
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
      environment = {
        enable = true; # a
      };
    };
    security = {
      #   # TODO
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
        #     opensnitch = { };
        fail2ban = {
          enable = true;
        };
        passwords = {
          vaultwarden.enable = true;
        };
        snapshots = {
          enable = true;
        };
        backups = {
          enable = true;
        };
        #     bleachBit = { };
        #     apparmor = { };
        #     firejail = { };
        #     clamav = { };
        gnupg = {
          enable = true;
        };
        polkit = {
          enable = true;
        };
      };
    };
    networking = {
      general = {
        # lanInterface = "enp0s31f6"; # a
        wifiInterface = "wlp1s0"; # a
        staticIp = null; # a
        defaultGateway = null; # a
        nameservers = [ "1.1.1.1" ]; # a
      };
      # firewall = { }; # a
      bridgedNetwork = {
        enable = false; # a (for wireguard)
      };
      wakeOnLan = {
        enable = false; # a
      };
      vpn = {
        wireguard = {
          client = {
            enable = true;
            address = [ "10.100.0.5/32" ];
            dns = [
              "192.168.2.11"
              "192.168.2.1"
            ];
            serverPublicKey = "hAvazVD4FMIbtZPLa5rtUXrZ3iXYIiW5Ivemyv1UmWA=";
          };
          server = { };
        };
      };
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
      gnome-power-manager.enable = true; # a
      upower.enable = true; # a
      powertop.enable = true;
      thermald.enable = true;
      tlp.enable = true; # a
      auto-cpufreq = {
        enable = true; # a
        thresholds = {
          enable = true; # a
          start_threshold = 90; # a
          stop_threshold = 95; # a
        };
        scaling = {
          enable = true; # a
          min_freq_MHz = 400; # a
          max_freq_MHz = 1000; # a
        };
      };
    };
    usb = {
      enable = true; # a
    };
    partitioning = {
      enable = true; # a
      diskAmount = 1; # a
    };
  };
  applications = {
    configurations = {
      server = {
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
        syncthing = {
          enable = true;
          devices = {
            "PC".id = "MIR6FXD-EEKYM5S-GQFPDZT-DWNCTYW-XGZNIGY-6CNO5C2-VOR6YPG-T3JCMAX";
            "PX8".id = "UPROPYX-AFK4Q5X-P5WRKRE-4VXJ5XU-QKTXML3-2SFWBV7-ELVVPDH-AOWS2QY";
            "T480".id = "Z3EA4H3-RNVAKPJ-JIWF4HD-L4AISEX-DUZZ4SV-P3E45GU-AKA3DHG-VYQNRAK";
            "T440P".id = "CAWY2HI-K3QLENX-QABH4C4-QDGBZAB-GH22BRL-ZB6YBG5-PXVDZTR-4MSF7QY";
            "SERVER".id = "OP5RCKE-UFEQ4IT-DRMANC2-425AFHE-RS4PG3Y-35VLH6F-7UJXUIJ-EAVK5A3";
          };
          folders = {
            "Dokumente" = {
              path = "/home/${config.system.user.general.primary}/Dokumente";
              devices = [
                "PC"
                # "T480"
                "T440P"
                "SERVER"
              ];
            };
            "Bilder" = {
              path = "/home/${config.system.user.general.primary}/Bilder";
              devices = [
                "PC"
                # "T480"
                "T440P"
                "SERVER"
              ];
            };
          };
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
        msmtp = {
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
        brave = {
          enable = true; # a
        };
        open-webui = {
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
  services.fwupd.enable = true;
}
