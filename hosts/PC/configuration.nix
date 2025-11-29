{
  lib,
  config,
  pkgs,
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
        name = "PC";
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
      bootloader = "limine";
      secureBoot = true;
      extraEntries = ''
        /NixOS (PC-SERVER)
          protocol: efi
          path: uuid(8f03e2df-020d-48b6-84c4-269f96c2ee85):/EFI/NixOS-boot/grubx64.efi

        /Windows 10
          protocol: efi
          path: uuid(883cb4fb-d274-4a40-8083-17d5e6fadaca):/EFI/Microsoft/Boot/bootmgfw.efi
      '';
      # osProber = false;
      # defaultEntry = 1;
      # extraEntries = ''
      #   menuentry "NixOs (PC-SERVER)" {
      #       insmod part_gpt
      #       insmod fat
      #       search --no-floppy --label SERVER_BOOT --set=root
      #       chainloader /EFI/NixOS-boot/grubx64.efi
      #   }
      #   menuentry "Windows 10 " {
      #       insmod part_gpt
      #       insmod fat
      #       search --no-floppy --label W10_BOOT --set=root
      #       chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      #   }
      # '';
    };
    desktop = {
      desktop-environments = {
        hyprland-desktop.enable = false;
        niri-desktop.enable = true;
      };
      theme = {
        colorSchemes = null;
        gtk = {
          enable = true;
          theme.name = "Adwaita";
          theme.package = null;
          cursor.name = "Bibata-Modern-Ice";
          cursor.package = null;
          icon.name = "WhiteSur-light";
          icon.package = "whitesur-icon-theme";
        };
        qt = {
          enable = true;
          theme.name = "adwaita";
          theme.package = null;
          style.name = "adwaita-light";
          style.package = null;
        };
      };
      components.session = {
        autoLogin = {
          enable = false;
        };
        autoShutdown = {
          enable = false;
          watchPort = toString config.services.ollama.port;
          shutdownTime = "1800"; # seconds
        };
      };
      environment = {
        enable = true;
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
        # opensnitch = { };
        fail2ban = {
          enable = true;
        };
        passwords = {
          vaultwarden.enable = true;
        };
        snapshots = {
          enable = false;
        };
        backups = {
          enable = false;
        };
        bleachBit = {
          enable = true;
        };
        # apparmor = { };
        # firejail = { };
        # smartd = {
        #   enable = true;
        # };
        clamav = {
          enable = true;
          interval = "*-*-* 17:00:00";
        };
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
        lanInterface = "eno1";
        wifiInterface = null;
        staticIp = "192.168.2.30";
        defaultGateway = "192.168.2.1";
        nameservers = [
          "192.168.2.11"
          "1.1.1.1"
        ];
      };
      # firewall = { };
      bridgedNetwork = {
        enable = false; # (for wireguard)
      };
      wakeOnLan = {
        enable = true;
      };
      vpn = {
        wireguard = {
          client = {
            enable = false;
          };
        };
      };
    };
    user = {
      general = {
        primary = "falk";
      };
      directories = {
        enable = true;
      };
    };
  };
  hardware = {
    fingerprint = {
      enable = false;
      # package = ;
    };
    Wooting = {
      enable = true;
    };
    drawingTablet = {
      enable = true;
    };
    blueTooth = {
      enable = true;
    };
    audio = {
      enable = true;
    };
    amdGpu = {
      enable = true;
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
      monitorType = "external";
    };
    powerManagement = {
      gnome-power-manager.enable = false;
      upower.enable = false;
      powertop.enable = false;
      thermald.enable = false;
      tlp.enable = false;
      auto-cpufreq = {
        enable = false;
        thresholds = {
          enable = true;
          start_threshold = 90;
          stop_threshold = 95;
        };
        scaling = {
          enable = true;
          min_freq_MHz = 400;
          max_freq_MHz = 1000;
        };
      };
    };
    usb = {
      enable = true;
    };
    partitioning = {
      enable = false;
      diskAmount = 1;
    };
  };
  applications = {
    configurations = {
      server = {
        ollama = {
          enable = true;
          dualSetup = true;
          modelDir = "/mnt/share/ollama/models";
          homeDir = "/mnt/share/ollama/home";
        };
      };
      client = {
        fileSharing = {
          enable = true;
          items = [
            {
              share = {
                "/mnt/cloud-fh" = {
                  device = "//192.168.2.12/cloud-fh";
                };
              };
            }
          ];
        };
        syncthing = {
          enable = true;
          devices = {
            # "PC".id = "MIR6FXD-EEKYM5S-GQFPDZT-DWNCTYW-XGZNIGY-6CNO5C2-VOR6YPG-T3JCMAX";
            "PX8".id = "UPROPYX-AFK4Q5X-P5WRKRE-4VXJ5XU-QKTXML3-2SFWBV7-ELVVPDH-AOWS2QY";
            "FW13".id = "N6F2GRB-VUPQC4F-DVNYES5-5KNJ36R-GGVAP2R-ZHHBV4U-UATR2JY-BRQ2NQ2";
            "T480".id = "Z3EA4H3-RNVAKPJ-JIWF4HD-L4AISEX-DUZZ4SV-P3E45GU-AKA3DHG-VYQNRAK";
            "T440P".id = "CAWY2HI-K3QLENX-QABH4C4-QDGBZAB-GH22BRL-ZB6YBG5-PXVDZTR-4MSF7QY";
            "SERVER".id = "OP5RCKE-UFEQ4IT-DRMANC2-425AFHE-RS4PG3Y-35VLH6F-7UJXUIJ-EAVK5A3";
          };
          folders = {
            "Dokumente" = {
              path = "/home/${config.system.user.general.primary}/Dokumente";
              devices = [
                # "PC"
                "T480"
                "FW13"
                "T440P"
                "SERVER"
              ];
            };
            "Bilder" = {
              path = "/home/${config.system.user.general.primary}/Bilder";
              devices = [
                # "PC"
                "T480"
                "FW13"
                "T440P"
                "SERVER"
              ];
            };
          };
        };
        virtualbox = {
          enable = false;
        };
        winboat = {
          enable = false;
        };
        qemu = {
          enable = false;
        };
        ssh = {
          enable = true;
        };
        msmtp = {
          enable = true;
        };
        thunar = {
          enable = false;
        };
        nautilus = {
          enable = true;
        };
        spotify = {
          enable = true;
        };
        firefox = {
          enable = false;
        };
        brave = {
          enable = true;
        };
        localsend = {
          enable = true;
        };
        open-webui = {
          enable = true;
        };
        foot = {
          enable = true;
        };
        kitty = {
          enable = false;
        };
        lf = {
          enable = false;
        };
        yazi = {
          enable = true;
        };
        tmux = {
          enable = true;
        };
        zsh = {
          enable = true;
        };
        neovim = {
          nixvim.enable = true;
          nvf.enable = false;
        };
        git = {
          enable = true;
          # username = config.system.user.general.primary;
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
            lang = true;
            tool = true;
            hypr = true;
            desk = true;
            power = true;
            game = true;
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
      flatpaks = {
        enable = true;
      };
      derivations = {
        enable = true;
      };
    };
  };

  specialisation = {
    Hyprland.configuration = {
      system.desktop.desktop-environments = {
        gnome-desktop.enable = lib.mkForce false;
        hyprland-desktop.enable = lib.mkForce true;
        niri-desktop.enable = lib.mkForce false;
      };
    };
  };
}
