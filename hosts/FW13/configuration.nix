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
      #   monitoring = { };
      features = {
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
        polkit = {
          enable = true;
        };
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
      # firewall = { }; # a
      bridgedNetwork = {
        enable = false; # a (for wireguard)
      };
      wakeOnLan = {
        enable = false; # a
      };
      vpn = {
        wireguard = {
          wireguard-client = {
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
  services.openssh.enable = true;
}
