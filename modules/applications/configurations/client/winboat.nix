{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  options = {
    applications.configurations.client.winboat = {
      enable = lib.mkEnableOption "Enables winboat module";
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.winboat;
    in
    lib.mkIf cfg.enable {
      # environment.systemPackages = [
      #   inputs.winboat.packages.${pkgs.system}.winboat
      #   pkgs.freerdp
      # ];
      # users.groups.docker.members = [ "${config.system.user.general.primary}" ];
      # virtualisation.docker.enable = true;
    };
}
