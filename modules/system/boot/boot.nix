{ lib, config, ... }:
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
    lib.mkIf cfg {
      boot.loader.systemd-boot.enable = false;
      boot.loader = {
        efi = {
          efiSysMountPoint = "/boot";
          canTouchEfiVariables = cfg.primaryBoot;
        };
        grub = {
          enable = true;
          device = "nodev";
          useOSProber = cfg.osProber;
          efiSupport = true;
          configurationName = "NixOS (${config.settings.general.name})";
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
