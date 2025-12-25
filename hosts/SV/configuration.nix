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
        name = "SV";
        nixosStateVersion = "25.11";
        homeManagerStateVersion = "25.11";
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
        autoLogin.enable = false;
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
        gnupg.enable = false;
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
        lanInterface = "xxx"; # TODO
        wifiInterface = null;
        staticIp = "192.168.2.25"; # TODO
        defaultGateway = "192.168.2.1";
        nameservers = [
          "1.1.1.1"
        ];
      };
      bridgedNetwork.enable = false; # (for wireguard)
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

  # networking.firewall.checkReversePath = false; # TODO does it change anything?
}
