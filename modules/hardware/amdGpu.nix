{
  lib,
  config,
  nixpkgs-stable,
  ...
}:
{
  options = {
    hardware.amdGpu = {
      enable = lib.mkEnableOption "Enables drivers and settings for amdGpus";
    };
  };

  config =
    let
      cfg = config.hardware.amdGpu;
    in
    lib.mkIf cfg.enable {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
      services.xserver.videoDrivers = [ "amdgpu" ];

      environment.systemPackages = with nixpkgs-stable; [
        lact
      ];

      systemd.services.lact = {
        description = "AMDGPU Control Daemon";
        after = [ "multi-user.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${nixpkgs-stable.lact}/bin/lact daemon";
        };
        enable = true;
      };

      # had to change /etc/lact/config.yaml (admin_group -> admin_groups (with - wheel and - sudo))
    };
}
