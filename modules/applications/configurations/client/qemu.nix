{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configurations.client.qemu = {
      enable = lib.mkEnableOption "Enables kvmqemu module";

    };
  };

  config =
    let
      cfg = config.applications.configurations.client.qemu;
    in
    lib.mkIf cfg.enable {
      programs.virt-manager = {
        enable = true;
        package = pkgs.virt-manager;
      };

      virtualisation.spiceUSBRedirection.enable = true;

      users.groups.libvirtd.members = [ "${config.system.user.general.primary}" ];
      users.groups.libvirt.members = [ "${config.system.user.general.primary}" ];

      environment.variables.LIBVIRT_DEFAULT_URI = "qemu:///system";

      virtualisation.libvirtd = {
        enable = true;
        package = pkgs.libvirt;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
          ovmf = {
            enable = true;
            packages = [
              (pkgs.OVMF.override {
                secureBoot = true;
                tpmSupport = true;
              }).fd
            ];
          };
        };
      };

      environment.systemPackages = with pkgs; [
        virt-viewer
        vde2
        dnsmasq
        bridge-utils
        netcat-openbsd
        libguestfs
        guestfs-tools
        libosinfo
      ];
      # Home Manager as NixOS module
      home-manager.users.${config.system.user.general.primary} =
        { config, ... }:
        {
          dconf.settings = {
            "org/virt-manager/virt-manager/connections" = {
              autoconnect = [ "qemu:///system" ];
              uris = [ "qemu:///system" ];
            };
          };
        };
    };
}
