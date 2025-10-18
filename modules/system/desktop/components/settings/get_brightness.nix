{ pkgs }:
pkgs.writeShellApplication {
  name = "get_brightness";
  runtimeInputs = with pkgs; [ brightnessctl ]; # not specifying inputs, makes it complain instead of downloading the inputs automatically
  text = ''
    if [ "$MONITOR_TYPE" == "internal" ]; then
      # system uses brightnessctl
      brightness=$(brightnessctl get)
      max_brightness=$(brightnessctl max)
      if [ -n "$brightness" ] && [ -n "$max_brightness" ]; then
        brightness_percent=$(( (brightness * 100) / max_brightness ))
        echo "$brightness_percent"
      fi
    fi
  '';
}
