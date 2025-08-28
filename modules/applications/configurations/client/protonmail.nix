{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configurations.client.protonmail = {
      enable = lib.mkEnableOption "Enables protonmail-bridge";
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.protonmail;
    in
    lib.mkIf cfg.enable {
      # after build:
      # execute "protonmail-bridge --cli"
      # then ">>> login" => type in protonmail credentials
      # wait for data pull
      # ">>> info" copy bridge password
      # ">>> exit"
      # "systemctl --user start protonmail-bridge.service"
      # log into thunderbird with bridge password

      # for use with thunderbird => (in thunderbird starttls -> none)

      services.protonmail-bridge = {
        enable = true;
        logLevel = "debug";
        path = with pkgs; [
          gnome-keyring
        ];
      };
      services.gnome.gnome-keyring.enable = true; # tool for managing passwords and keys (settings password to "" makes it stop promting at boot)
      programs.seahorse.enable = true; # Optional GUI for managing gnome-keyrings
      services.passSecretService.enable = true; # idk if this is  needed, seemed to fail without
    };
}
