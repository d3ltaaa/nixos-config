{ lib, config, ... }:
{
  options = {
    system.general.locale = {
      language = lib.mkOption {
        type = lib.types.str;
        default = "en";
      };
      timeZone = lib.mkOption {
        type = lib.types.str;
        default = "Europe/Berlin";
      };
      keyboardLayout = lib.mkOption {
        type = lib.types.str;
        default = "de";
      };
    };
  };

  config =
    let
      cfg = config.system.general.locale;
    in
    {
      time.timeZone = cfg.timeZone;

      i18n.defaultLocale = lib.mkIf (cfg.language == "en") "en_US.UTF-8";

      i18n.extraLocaleSettings = lib.mkIf (cfg.keyboardLayout == "de") {
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
      };

      # Configure console keymap
      console.keyMap = lib.mkIf (cfg.keyboardLayout == "de") "de";

      services.xserver.xkb = lib.mkIf (cfg.keyboardLayout == "de") {
        layout = "de";
        variant = "";
      };
    };
}
