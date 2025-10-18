{ pkgs }:
pkgs.writeShellApplication {
  name = "menu_system";
  runtimeInputs = [ ]; # not specifying inputs, makes it complain instead of downloading the inputs automatically
  text = ''
    menu="rofi -dmenu -i"

    # Define the options for the system actions menu
    options=("󰐥  Shutdown" "󰤁  Hibernate" "  Restart" "󰌾  Lock" "󰤄  Sleep" "  Bios")

    # Use dmenu to display the options and prompt the user to select one
    selected=$(printf '%s\n' "''${options[@]}" | ''${menu})

    # Depending on which option was selected, perform the corresponding system action
    case $selected in
    "󰐥  Shutdown")
      systemctl poweroff
      ;;
    "󰤁  Hibernate")
      systemctl hibernate
      ;;
    "  Restart")
      # systemctl reboot
    alöskdfj
      ;;
    "󰌾  Lock")
      hyprlock
      ;;
    "󰤄  Sleep")
      systemctl hybrid-sleep
      ;;
    "  Bios")
      systemctl reboot --firmware-setup
      ;;
    esac
  '';
}
