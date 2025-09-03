{ lib, config, ... }:
{
  options = {
    hardware.partitioning = {
      enable = lib.mkEnableOption "Enables partitioning module";
      diskAmount = lib.mkOption {
        type = lib.types.int;
        default = 1;
      };
    };
  };

  config =
    let
      cfg = config.hardware.partitioning;
    in
    lib.mkIf cfg.enable {
      boot.initrd.luks.devices = lib.mkMerge (
        [
          # Always add swap encryption
          {
            "crypt_swap".device = "/dev/disk/by-label/CRYPT_SWAP";
          }
        ]
        ++ (map (
          diskNum:
          # Add BTRFS encryption for each disk
          {
            "crypt_btrfs${if diskNum == 1 then "" else "_${toString diskNum}"}" = {
              device = "/dev/disk/by-label/CRYPT_BTRFS${if diskNum == 1 then "" else "_${toString diskNum}"}";
            };
          }) (lib.range 1 cfg.diskAmount))
      );

      fileSystems."/" = {
        device = "/dev/disk/by-label/FS_BTRFS";
        fsType = "btrfs";
        options = [ "subvol=@" ];
      };

      fileSystems."/home" = {
        device = "/dev/disk/by-label/FS_BTRFS";
        fsType = "btrfs";
        options = [ "subvol=@home" ];
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-label/FS_BOOT";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = [
        { device = "/dev/mapper/crypt_swap"; }
      ];
    };
}
