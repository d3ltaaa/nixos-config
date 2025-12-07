{ pkgs, config }:
pkgs.writeShellApplication {
  name = "menu_system";
  runtimeInputs = [ ]; # not specifying inputs, makes it complain instead of downloading the inputs automatically
  text =
    let
      cfg-components = config.system.desktop.components;
      menu =
        if cfg-components.rofi.enable then
          ''
            ${pkgs.rofi}/bin/rofi -dmenu -i -theme-str '@theme "powermenu"'
          ''
        else
          "";
    in
    ''
      # Define the options for the system actions menu
      options=("󰐥" "󰤁" "" "󰌾" "󰤄" "")

      # Use dmenu to display the options and prompt the user to select one
      selected=$(printf '%s\n' "''${options[@]}" | ${menu})

      # Depending on which option was selected, perform the corresponding system action
      case $selected in
      "󰐥")
        systemctl poweroff
        ;;
      "󰤁")
        systemctl hibernate
        ;;
      "")
        systemctl reboot
        ;;
      "󰌾")
        hyprlock
        ;;
      "󰤄")
        systemctl hybrid-sleep
        ;;
      "")
        systemctl reboot --firmware-setup
        ;;
      esac
    '';
}
