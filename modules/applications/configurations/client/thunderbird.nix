{ lib, config, ... }:
{
  options = {
    applications.configurations.client.thunderbird = {
      enable = lib.mkEnableOption "Enables Thunderbird";
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.thunderbird;
    in
    lib.mkIf cfg.enable {
      programs.thunderbird = {
        enable = true;
        preferencesStatus = "user";
      };
    };
}
