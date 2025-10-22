{ lib, config, ... }:
{
  # accessible for root at /etc/credentials
  secrets = {
    serverAddress = lib.strings.trim (builtins.readFile "/etc/credentials/server_address");
    githubUsername = lib.strings.trim (builtins.readFile "/etc/credentials/github/username");
    githubEmail = lib.strings.trim (builtins.readFile "/etc/credentials/github/email");
  };

  imports = [
    ./hardware-configuration.nix
  ];

  system = {
    general = {
      nixos = {
        name = "VM2"; # a
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
          interval = "*-*-* 19:00:00";
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
        fierfly.enable = true;
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
      };
    };
    packages = {
      nixpkgs = {
        extraPackages = [ ]; # a
        pkgs = {
          system = {
            default = false; # a
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
