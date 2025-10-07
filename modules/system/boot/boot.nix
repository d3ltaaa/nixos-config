{
  lib,
  config,
  nixpkgs-stable,
  ...
}:
{
  options = {
    system.boot = {
      primaryBoot = lib.mkEnableOption "";
      osProber = lib.mkEnableOption "Enable Os-Prober";
      bootloader = lib.mkOption {
        type = lib.types.enum [
          "grub"
          "limine"
        ];
      };
      defaultEntry = lib.mkOption {
        type = lib.types.int;
        default = 0;
      };
      extraEntries = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      secureBoot = lib.mkEnableOption "Enables SecureBoot (first enroll keys)";
    };
  };

  config =
    let
      cfg = config.system.boot;
    in
    {
      boot.initrd.systemd.enable = true;
      boot.initrd.verbose = false;
      boot.loader.systemd-boot.enable = false;
      boot = {
        plymouth = {
          enable = true;
          # theme = "spinner_alt";
          # themePackages = with nixpkgs-stable; [
          #   # By default we would install all themes
          #   (adi1090x-plymouth-themes.override {
          #     selected_themes = [ "spinner_alt" ];
          #   })
          # ];
          logo = "${nixpkgs-stable.nixos-icons}/share/icons/hicolor/48x48/apps/nix-snowflake-white.png";
        };

        # Enable "Silent boot"
        consoleLogLevel = 3;
        kernelParams = [
          "quiet"
          "splash"
          "boot.shell_on_fail"
          "udev.log_priority=3"
          "rd.systemd.show_status=auto"
        ];
        # Hide the OS choice for bootloaders.
        # It's still possible to open the bootloader list by pressing any key
        # It will just not appear on screen unless a key is pressed

      };
      environment.systemPackages = with nixpkgs-stable; [ sbctl ];
      boot.loader = {
        efi = {
          efiSysMountPoint = "/boot";
          canTouchEfiVariables = cfg.primaryBoot;
        };
        limine = lib.mkIf (cfg.bootloader == "limine") {
          enable = true;
          secureBoot.enable = cfg.secureBoot;
          # lsblk -o NAME,PARTUUID,UUID,LABEL,FSTYPE,MOUNTPOINT
          extraEntries = if cfg.extraEntries != null then cfg.extraEntries else "";
          style = {
            wallpapers = [ ];
            interface = {
              branding = "Bootloader";
              brandingColor = 4;
            };
            graphicalTerminal = {
              palette = "1e2030;ed8796;a6da95;eed49f;8aadf4;c6a0f6;8bd5ca;cad3f5";
              brightPalette = "494d64;ed8796;a6da95;eed49f;8aadf4;c6a0f6;8bd5ca;cad3f5";
              foreground = "ffffff";
              background = "000000";
              brightForeground = "000000";
              brightBackground = "5b6078";
            };
          };
        };
        grub = lib.mkIf (cfg.bootloader == "grub") {
          enable = true;
          device = "nodev";
          gfxmodeEfi = "1920x1200x32";
          theme = nixpkgs-stable.minimal-grub-theme;
          useOSProber = cfg.osProber;
          efiSupport = true;
          configurationName = "NixOS (${config.system.general.nixos.name})";
          default = lib.mkIf (cfg.defaultEntry != null) cfg.defaultEntry;
          extraEntries =
            let
              defaultEntries = ''
                menuentry "Reboot" {
                    reboot
                }
                menuentry "Poweroff" {
                    halt
                }
                menuentry "Enter UEFI Firmware Settings" {
                    fwsetup
                }
              '';
            in
            (if cfg.extraEntries != null then cfg.extraEntries else "") + defaultEntries;
        };
      };
    };
}
