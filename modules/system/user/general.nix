{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    system.user.general = {
      primary = lib.mkOption {
        type = lib.types.str;
        default = "falk";
      };
    };
  };

  config =
    let
      cfg = config.system.user.general;
    in
    lib.mkIf cfg.enable {
      users.users.${cfg.primary} = {
        isNormalUser = true;
        initialPassword = "${cfg.primary}";
        description = "${cfg.primary}";
        extraGroups = [
          "networkmanager"
          "wheel"
          "video"
          "audio"
        ];
        shell = pkgs.zsh;
      };
      security.polkit.enable = true;
      security.polkit.debug = true;
    };
}
