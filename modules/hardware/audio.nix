{
  lib,
  config,
  nixpkgs-stable,
  ...
}:
{
  options = {
    hardware.audio = {
      enable = lib.mkEnableOption "Enable Audio";
    };
  };

  config =
    let
      cfg = config.hardware.audio;
    in
    lib.mkIf cfg.enable {
      services = {
        # pulseaudio.enable = true;
        # pulseaudio.support32Bit = true;
        pipewire = {
          enable = true;
          package = nixpkgs-stable.pipewire;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
        };

      };
      environment.systemPackages = with nixpkgs-stable; [
        pulseaudio # for pactl (needed for scripts)
      ];

    };
}
