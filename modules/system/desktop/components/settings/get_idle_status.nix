{ pkgs, config }:
pkgs.writeShellApplication {
  name = "get_idle_status";
  runtimeInputs = [ ]; # not specifying inputs, makes it complain instead of downloading the inputs automatically
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
      icon_idle=""
      tooltip_text=""
      if [[ $(systemctl --user is-active ${idle_service}.service) == "active" ]]; then
        icon_idle=" "
        tooltip_text="${idle_service} active"
      else
        icon_idle="󱣴 "
        tooltip_text="${idle_service} inactive"
      fi
      echo "{\"text\": \"$icon_idle\", \"tooltip\": \"$tooltip_text\" }"
    '';
}
