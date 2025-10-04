{
  lib,
  config,
  nixpkgs-stable,
  ...
}:
{
  options = {
    applications.configurations.client.brave = {
      enable = lib.mkEnableOption "Enables Brave Browser";
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.brave;
    in
    lib.mkIf cfg.enable {
      environment.variables = {
        NIXOS_OZONE_WL = 1;
      };
      programs.chromium.enable = true;

      environment.systemPackages = with nixpkgs-stable; [ brave ];
    };
}
