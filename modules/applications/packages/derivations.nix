{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  options = {
    applications.packages.derivations = {
      enable = lib.mkEnableOption "Enables derivations";
    };
  };

  config =
    let
      cfg = config.applications.packages.derivations;
      fscripts = import ./derivations/fscripts.nix { inherit pkgs inputs; };
      derivations = [
        # fscripts
      ]; # add to list
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = derivations;
    };
}
