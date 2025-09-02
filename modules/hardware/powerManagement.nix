{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    hardware.powerManagement = {
      gnome-power-manager.enable = lib.mkEnableOption "Enables the gnome-power-manager-gui";
      upower.enable = lib.mkEnableOption "Enables Upower";
      thermald.enable = lib.mkEnableOption "Enables Thermald";
      powertop.enable = lib.mkEnableOption "Enables Powertop";
      tlp.enable = lib.mkEnableOption "Enables Tlp";
      auto-cpufreq = {
        enable = lib.mkEnableOption "Enables Auto-cpufreq";
        thresholds = {
          enable = lib.mkEnableOption "Enables thresholds";
          start_threshold = lib.mkOption {
            type = lib.types.int;
          };
          stop_threshold = lib.mkOption {
            type = lib.types.int;
          };
        };
        scaling = {
          enable = lib.mkEnableOption "Enables Auto-cpufreq cpu-scaling";
          min_freq_MHz = lib.mkOption {
            type = lib.types.int;
          };
          max_freq_MHz = lib.mkOption {
            type = lib.types.int;
          };
        };
      };
    };
  };

  config =
    let
      cfg = config.hardware.powerManagement;
    in
    {

      # power-profiles-daemon conflicts with tlp and auto-cpufreq
      services.power-profiles-daemon.enable = lib.mkIf (
        config.hardware.powerManagement.auto-cpufreq.enable == true
        || config.hardware.powerManagement.tlp.enable == true
      ) (lib.mkForce false);

      services.upower.enable = cfg.upower.enable;

      powerManagement.powertop.enable = cfg.powertop.enable;

      services.thermald.enable = cfg.thermald.enable;

      services.tlp = {
        settings = {
          enable = cfg.tlp.enable;
          CPU_SCALING_GOVERNOR_ON_AC = "";
          CPU_SCALING_GOVERNOR_ON_BAT = "";

          CPU_ENERGY_PERF_POLICY_ON_AC = "";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "";

          PLATFORM_PROFILE_ON_AC = "";
          PLATFORM_PROFILE_ON_BAT = "";

          PCIE_ASPM_ON_AC = "performance";
          PCIE_ASPM_ON_BAT = "powersupersave";

          DEVICES_TO_ENABLE_ON_STARTUP = "wifi";
          DEVICES_TO_DISABLE_ON_STARTUP = "nfc wwan";
          DEVICES_TO_DISABLE_ON_SHUTDOWN = "nfc wifi wwan";
          DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "nfc wifi wwan";

          DEVICES_TO_DISABLE_ON_WIFI_CONNECT = "wwan";
          DEVICES_TO_DISABLE_ON_WWAN_CONNECT = "wifi";

          WOL_DISABLE = "N";

          # CPU_SCALING_GOVERNOR_ON_AC = "performance";
          # CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          #
          # CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          # CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
          #
          # PLATFORM_PROFILE_ON_AC = "performance";
          # PLATFORM_PROFILE_ON_BAT = "low-power";
          #
          # CPU_BOOST_ON_AC = 1;
          # CPU_BOOST_ON_BAT = 1;
          #
          # CPU_HWP_DYN_BOOST_ON_AC = 1;
          # CPU_HWP_DYN_BOOST_ON_BAT = 1;

          #CPU_MIN_PERF_ON_AC = 0;
          #CPU_MAX_PERF_ON_AC = 100;
          #CPU_MIN_PERF_ON_BAT = 0;
          #CPU_MAX_PERF_ON_BAT = 20;

          #Optional helps save long term battery health
          # START_CHARGE_THRESH_BAT0 = 60; # 60 and below it starts to charge
          # STOP_CHARGE_THRESH_BAT0 = 90; # 90 and above it stops charging

        };
      };

      services.auto-cpufreq = {
        enable = cfg.auto-cpufreq.enable;
        settings = {
          battery = {
            governor = "powersave";
            energy_performance_bias = "power";
            energy_performance_preference = "power";
            turbo = "auto";
            enable_thresholds = cfg.auto-cpufreq.thresholds.enable;
            start_threshold = cfg.auto-cpufreq.thresholds.start_threshold;
            stop_threshold = cfg.auto-cpufreq.thresholds.stop_threshold;
            scaling_min_freq = lib.mkIf (cfg.auto-cpufreq.scaling.enable) (
              cfg.auto-cpufreq.scaling.min_freq_MHz * 1000
            );
            scaling_max_freq = lib.mkIf (cfg.auto-cpufreq.scaling.enable) (
              cfg.auto-cpufreq.scaling.max_freq_MHz * 1000
            );
          };
          charger = {
            governor = "performance";
            turbo = "auto";
          };
        };
      };

      environment.systemPackages = lib.mkIf (cfg.gnome-power-manager.enable && cfg.upower.enable) [
        pkgs.gnome-power-manager
      ];

      home-manager.users.${config.system.user.general.primary} =
        { config, ... }:
        {
          xdg.desktopEntries.open-webui = lib.mkIf (cfg.gnome-power-manager.enable && cfg.upower.enable) {
            name = "Gnome Power Manager";
            exec = "gnome-power-statistics";
            startupNotify = false;
            terminal = false;
            icon = "gnome-power-manager";
          };
        };
    };
}
