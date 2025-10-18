{ pkgs }:
pkgs.writeShellApplication {
  name = "script_light";
  runtimeInputs = with pkgs; [
    gammastep
    brightnessctl
    ddcutil
  ]; # not specifying inputs, makes it complain instead of downloading the inputs automatically
  text =
    let
      # get_monitor_count_cmd = "$(hyprctl monitors all | grep Monitor | wc -l)";
      get_monitor_count_cmd = "$(niri msg outputs | grep -c Output)";
    in
    ''
      #!/run/current-system/sw/bin/bash
      monitor_count=${get_monitor_count_cmd}

      if [[ "$MONITOR_TYPE" == "internal" ]]; then
        # cmd_more="brillo -A 10"
        # cmd_less="brillo -U 10"
        # cmd_max="brillo -S 100"
        # cmd_min="brillo -S 0"
        cmd_more="brightnessctl set +10%"
        cmd_less="brightnessctl set 10%-"
        cmd_max="brightnessctl set 100%"
        cmd_min="brightnessctl set 0%"
      elif [[ "$MONITOR_TYPE" == "external" ]]; then
        cmd_max=""
        cmd_min=""
        cmd_more=""
        cmd_less=""
        for i in $(seq 1 "$monitor_count"); do
          cmd_more+="ddcutil --display $i setvcp 10 + 10"
          cmd_less+="ddcutil --display $i setvcp 10 - 10"
          cmd_max+="ddcutil --display $i setvcp 10 100"
          cmd_min+="ddcutil --display $i setvcp 10 0"
          if [[ $i != "$monitor_count" ]]; then
            cmd_max+=" && "
            cmd_min+=" && "
            cmd_more+=" && "
            cmd_less+=" && "
          fi
        done
      fi

      echo "$cmd_more"
      echo "$cmd_less"

      light_down() {

        case "$1" in
        "max")
          eval "$cmd_min"
          exit 0
          ;;
        *)
          eval "$cmd_less"
          exit 0
          ;;
        esac
      }

      light_up() {

        case "$1" in
        "max")
          eval "$cmd_max"
          exit 0
          ;;
        *)
          eval "$cmd_more"
          exit 0
          ;;
        esac
      }

      case "$1" in

      "up")
        light_up up
        ;;

      "down")
        light_down down
        ;;

      "blue")
        gammastep -O 6500
        ;;

      "red")
        gammastep -O 4000 
        ;;

      "day")
        light_up max
        ;;
      "night")
        light_down max
        ;;
      *) echo "unknown command" && exit 1 ;;

      esac
    '';
}
