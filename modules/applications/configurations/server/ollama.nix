{
  lib,
  config,
  nixpkgs-stable,
  ...
}:
{
  options = {
    applications.configurations.server.ollama = {
      enable = lib.mkEnableOption "Enables Ollama module";
      dualSetup = lib.mkEnableOption "Is ollama running on two systems on the same pc?";
      modelDir = lib.mkOption {
        type = lib.types.str;
        default = "/mnt/share/ollama/models";
      };
      homeDir = lib.mkOption {
        type = lib.types.str;
        default = "/mnt/share/ollama/home";
      };
    };
  };

  config =
    let
      cfg = config.applications.configurations.server.ollama;
    in
    lib.mkIf cfg.enable {
      services.ollama = {
        enable = true;
        openFirewall = lib.mkIf cfg.dualSetup true;
        host = lib.mkIf cfg.dualSetup "0.0.0.0";
        user = "ollama";
        models = cfg.modelDir;
        home = cfg.homeDir;
        loadModels = [
        ];

        # only on amd-gpu
        package = lib.mkIf config.hardware.amdGpu.enable nixpkgs-stable.ollama-rocm;
        acceleration = lib.mkIf config.hardware.amdGpu.enable "rocm";
        rocmOverrideGfx = "11.0.0"; # 7900xt (gpu-family)
      };

      # match uid on systems
      users.users.ollama = lib.mkIf cfg.dualSetup {
        uid = 995;
      };

      systemd.services.ollama = {
        serviceConfig = {
          ExecStartPre = "/run/current-system/sw/bin/sleep 10"; # add delay, did not find solution for race problem
          ReadWritePaths = lib.mkIf cfg.dualSetup [
            "${config.services.ollama.models}"
            "${config.services.ollama.home}"
          ];
        };
      };

      systemd.services.ollama-model-loader.serviceConfig = {
        ReadWritePaths = lib.mkIf cfg.dualSetup [
          "${config.services.ollama.models}"
          "${config.services.ollama.home}"
        ];
      };
    };
}
