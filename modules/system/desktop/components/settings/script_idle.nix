{ pkgs, config }:
pkgs.writeShellApplication {
  name = "script_idle";
  runtimeInputs = [ ];
  text =
    let
      idle_service =
        if config.system.desktop.components.hypridle.enable then
          "hypridle"
        else if config.system.desktop.components.swayidle.enable then
          "swayidle"
        else
          "";
    in
    ''
      if [[ $(systemctl --user is-active ${idle_service}.service) == "active" ]]; then
        systemctl --user stop ${idle_service}.service
      else
        systemctl --user start ${idle_service}.service
      fi
      pkill -RTMIN+6 waybar
    '';
}
