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
    githubUsername = lib.strings.trim (builtins.readFile "/etc/credentials/github/username");
    githubEmail = lib.strings.trim (builtins.readFile "/etc/credentials/github/email");
    monitoringEmail = lib.strings.trim (builtins.readFile "/etc/credentials/monitoring/email");
  };

  system = {
    general = {
      nixos = {
        name = "MC";
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
          enable = false; # monitored
          interval = "*-*-* 17:00:00";
        };
      };
    };
    networking = {
      general = {
        lanInterface = "ens18";
        wifiInterface = null;
        staticIp = "192.168.2.20";
        defaultGateway = "192.168.2.1";
        nameservers = [
          "1.1.1.1"
        ];
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
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true; # Opens the port the server is running on (by default 25565 but in this case 43000)
    declarative = true;
    whitelist = {
    };
    serverProperties = {
      server-port = 43000;
      difficulty = 3;
      gamemode = 1;
      max-players = 5;
      motd = "NixOS Minecraft server!";
      white-list = false;
      allow-cheats = true;
    };
    jvmOpts = "-Xms2048M -Xmx4096M";
  };

}
