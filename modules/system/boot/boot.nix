{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.boot = {
      primaryBoot = lib.mkEnableOption "";
      osProber = lib.mkEnableOption "Enable Os-Prober";
      defaultEntry = lib.mkOption {
        type = lib.types.int;
        default = 0;
      };
      extraEntries = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
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
          # themePackages = with pkgs; [
          #   # By default we would install all themes
          #   (adi1090x-plymouth-themes.override {
          #     selected_themes = [ "spinner_alt" ];
          #   })
          # ];
          logo = "${pkgs.nixos-icons}/share/icons/hicolor/48x48/apps/nix-snowflake-white.png";
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
      boot.loader = {
        efi = {
          efiSysMountPoint = "/boot";
          canTouchEfiVariables = cfg.primaryBoot;
        };
        grub = {
          enable = true;
          device = "nodev";
          gfxmodeEfi = "1920x1200x32";
          theme = pkgs.minimal-grub-theme;
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
