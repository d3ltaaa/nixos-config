{ pkgs }:
pkgs.writeShellApplication {
  name = "menu_system_new";
  runtimeInputs = [ ];
  text = ''
    menu="rofi -dmenu -i"
    menu_alt=''$menu
    notification_normal="dunstify -u normal"
    notification_urgent="dunstify -u critical"
    terminal="''$(echo ''$TERMINAL)"

    menu_main() {
      # Define first layer
      options=(" Wifi" "󰂯 Bluetooth" "󰕾 Audio" "󰍹 Monitors" " Wallpaper" " Light" "󰓅 Energy-Mode" "󱊞 USB" " Nixos Config" "󰅙 Close")

      # display options
      selected=''$(printf '%s\n' "''${options[@]}" | ''${menu} " Settings")

      case ''$selected in
      " Wifi")
        menu_wifi
        ;;
      "󰂯 Bluetooth")
        menu_blue
        ;;
      "󰕾 Audio")
        menu_vol
        ;;
      "󰍹 Monitors")
        menu_mon
        ;;
      " Wallpaper")
        menu_wall
        ;;
      " Light")
        menu_light
        ;;
      "󰓅 Energy-Mode")
        menu_energy
        ;;
      "󱊞 USB")
        menu_usb
        ;;
      " Nixos Config")
        menu_updates
        ;;
      "󰅙 Close") ;;
      esac
    }

    menu_wifi() {
      hyprctl dispatch exec "[float;size 800 500] ''$terminal impala"
    }

    menu_blue() {
      hyprctl dispatch exec "[float;size 800 500] ''$terminal bluetui"
    }

    menu_vol() {
      hyprctl dispatch exec "[float;size 800 500] ''$terminal pulsemixer"
    }

    menu_tablet() {

      status_kb=''$(xinput list-props 12 | grep "Device Enabled" | awk '{print ''$4}')
      status_kb_short=""
      if [[ ''$status_kb = 1 ]]; then
        status_kb_short="󰓶  Go Tablet-mode"
      elif [[ ''$status_kb = 0 ]]; then
        status_kb_short="  Go Laptop-mode"
      fi

      options=("''$status_kb_short" "  Go back")

      selected=''$(printf '%s\n' "''${options[@]}" | ''${menu_alt})

      case ''$selected in
      ''$status_kb_short)

        if [[ ''$status_kb = 1 ]]; then
          xinput disable 12
        elif [[ ''$status_kb = 0 ]]; then
          xinput enable 12
        fi
        ;;
      "  Go back")
        menu_options
        ;;
      esac
    }

    menu_mon() {
      hyprctl dispatch exec "[float;size 1000 700] nwg-displays"
    }

    menu_wall() {
      # hyprctl dispatch exec "[float;size 1000 1000] waypaper"
      output="''$(waypaper)"

      # Extract the filename using grep and sed
      selected_file=''$(echo "''$output" | grep "Selected file:" | tail -n 1 | sed 's/Selected file: //')

      # Ensure the destination directory exists
      mkdir -p ~/.config/wall

      # Remove any existing symlink or file
      rm -f ~/.config/wall/paper

      # Create the new symlink
      ln -s "''$selected_file" ~/.config/wall/paper

      echo "Symlink created: ~/.config/wall/paper -> ''$selected_file"
    }

    menu_light() {
      options=("  Brightness" "  Redshift" "  Go back")
      selected=''$(printf '%s\n' "''${options[@]}" | ''${menu_alt})

      case "''$selected" in
      "  Brightness")
        while true; do
          options=("  +10%" "  -10%" "  Max Brightness" "  Lowest Brightness" "  Go back")
          further_selected=''$(printf '%s\n' "''${options[@]}" | ''${menu} "Brightness:")
          case "''$further_selected" in
          "  +10%")
            scr_light up
            ;;
          "  -10%")
            scr_light down
            ;;
          "  Max Brightness")
            scr_light day
            ;;
          "  Lowest Brightness")
            scr_light night
            ;;
          "  Go back")
            break
            ;;
          *)
            echo "Error: Wrong input for src_light!"
            ;;
          esac
        done
        if [[ ''$further_selected == "  Go back" ]]; then
          menu_light
        fi
        ;;

      "  Redshift")
        while true; do
          options=("  Blue-light-filter on" "  Blue-light-filter off" "  Go back")
          further_selected=''$(printf '%s\n' "''${options[@]}" | ''${menu} "Blue light:")
          case "''$further_selected" in
          "  Blue-light-filter off")
            scr_light blue
            ;;
          "  Blue-light-filter on")
            scr_light red
            ;;
          "  Go back")
            break
            ;;
          *)
            echo "Error: Wrong input for src_light!"
            ;;
          esac
        done
        if [[ ''$further_selected == "  Go back" ]]; then
          menu_light
        fi
        ;;
      "  Go back")
        menu_options
        ;;
      esac

    }

    menu_energy() {
      options=("  Reset" "󱧥  Powersave" "󰓅  Performance" "  Go back")

      # Use dmenu to display the options and prompt the user to select one
      selected=''$(printf '%s\n' "''${options[@]}" | ''${menu})

      # Depending on which option was selected, perform the corresponding system action
      case ''$selected in
      "  Reset")  hyprctl dispatch exec "[float;size 800 500] ''$terminal sudo auto-cpufreq --force reset" ;;
      "󱧥  Powersave") hyprctl dispatch exec "[float;size 800 500] ''$terminal sudo auto-cpufreq --force powersave" ;;
      "󰓅  Performance") hyprctl dispatch exec "[float;size 800 500] ''$terminal sudo auto-cpufreq --force performance" ;;
      "  Go back") menu_main ;;
      esac
    }

    menu_themes() {
      options=("Arch-Dark" "Arch-Light" "Arch-Cyan" "Triangle-Blue" "  Go back")
      selected=''$(printf '%s\n' "''${options[@]}" | ''${menu} "Select Theme:")

      case ''$selected in
      "Arch-Dark")
        set-arch-dark
        ;; #

      "Arch-Light")
        set-arch-light
        ;;

      "Arch-Cyan")
        set-arch-cyan
        ;;

      "Triangle-Blue")
        set-triangle-blue
        ;;
      "  Go back")
        menu_options
        ;;
      esac
    }

    menu_server() {

      connection_lan=''$(nmcli -t -f NAME connection show --active | head -n 1)

      connection_wifi=''$(nmcli radio wifi)

      if [[ ''$connection_lan == "Wired connection 1" ]]; then
        status="Enabled - Wired"
      elif [[ ''$connection_wifi == "enabled" && ''$connection_lan == "lo" ]]; then
        status="Enabled - Not Connected"
      elif [[ ''$connection_wifi == "enabled" ]]; then
        status="Enabled - Connected to ''$(nmcli -t -f NAME connection show --active | head -n 1)"
      else
        status="Disabled"
      fi

      options=("  Internet (''$status)" "  Clients" "  Phone" "  Go back")
      selected=''$(printf '%s\n' "''${options[@]}" | ''${menu_alt})

      case ''$selected in
      "  Internet (''$status)")
        menu_wifi
        ;;

      "  Clients")

        options_list=(''$(grep -w Host ~/.ssh/config | awk '{print ''$2}'))
        options_list+=("  Go back")
        selected_list=''$(printf '%s\n' "''${options_list[@]}" | ''${menu_alt})

        case ''$selected_list in
        "  Go back")
          menu_server
          ;;
        *)
          st -e bash -c "
                        echo Connecting to ''$selected_list...
                        ssh ''$selected_list
                        "
          ;;
        esac
        ;;

      "  Phone")

        options=("󰋫  Get Remnote images" "󰋫  Get Images" "󰈙  Get Documents" "  Go back")
        selected=''$(printf '%s\n' "''${options[@]}" | ''${menu_alt})

        case ''$selected in

        "󰋫  Get Remnote images")
          st -e bash -c "
                        transfer_from_remote.sh ~/Pictures/Remnote
                        "
          ;;
        "󰋫  Get Images")
          st -e bash -c "
                        transfer_from_remote.sh ~/Pictures/Server
                        "
          ;;
        "󰈙  Get Documents")
          st -e bash -c "
                        transfer_from_remote.sh ~/Documents
                        "
          ;;
        "  Go back")
          menu_server
          ;;
        esac
        ;;

      esac

    }

    menu_usb() {

      #devices found by udisksctl
      lsblk_print=''$(lsblk -no name,type,mountpoints | grep -A1 disk)

      devices=(''$(lsblk -no name,type | grep disk | awk '{print ''$1}'))

      mounted_usb_devices=()

      unmounted_usb_devices=()

      usb_devices=()

      for device in "''${devices[@]}"; do
        connection_type=''$(lsblk -no tran /dev/''$device)
        is_mounted=''$(lsblk -no mountpoints,name | grep ''$device | awk '{print ''$2}')
        if [[ ''$connection_type == "usb" ]]; then

          usb_devices+=("''$device")

          if [[ ! ''$is_mounted == "" ]]; then
            mounted_usb_devices+=("''$device")
          else
            unmounted_usb_devices+=("''$device")
          fi

        fi
      done

      # Iterate the loop to read and print each array element

      pretty_mounted_names=()

      for value in "''${mounted_usb_devices[@]}"; do
        # get the name of ''$value
        properties=''$(udevadm info --query=property --name=/dev/''$value)
        vendor=''$(echo "''$properties" | grep -e "ID_VENDOR=" | awk -F "=" '{print ''$2}')
        model=''$(echo "''$properties" | grep -e "ID_MODEL=" | awk -F "=" '{print ''$2}')
        pretty_mounted_names+=("''$value -- ''$vendor ''$model")

      done

      mounted_usb_names=''$(
        for value in "''${pretty_mounted_names[@]}"; do
          echo ''$value
        done
      )

      pretty_unmounted_names=()

      for value in "''${unmounted_usb_devices[@]}"; do
        # get the name of ''$value
        properties=''$(udevadm info --query=property --name=/dev/''$value)
        vendor=''$(echo "''$properties" | grep -e "ID_VENDOR=" | awk -F "=" '{print ''$2}')
        model=''$(echo "''$properties" | grep -e "ID_MODEL=" | awk -F "=" '{print ''$2}')
        pretty_unmounted_names+=("''$value -- ''$vendor ''$model")

      done

      unmounted_usb_names=''$(
        for value in "''${pretty_unmounted_names[@]}"; do
          echo ''$value
        done
      )

      echo "M:''${pretty_mounted_names[0]}"

      echo "U:''${pretty_unmounted_names[0]}"

      options=("󰕓  Mount" "  Unmount" "  Go back")

      selected=''$(printf '%s\n' "''${options[@]}" | ''${menu_alt})

      mounted_options=("''$mounted_usb_names" "  Go back")

      unmounted_options=("''$unmounted_usb_names" "  Go back")

      echo ''$mounted_options

      echo ''$unmounted_options

      case ''$selected in
      "󰕓  Mount")
        new_selected=''$(printf '%s\n' "''${unmounted_options[@]}" | ''${menu_alt} | awk '{print ''$1}')
        case ''$new_selected in
        "  Go back")
          menu_options usb
          ;;
        *)
          udisksctl mount -b /dev/''${new_selected} && ''${notification_normal} "''$new_selected mounted" || udisksctl mount -b /dev/''${new_selected}1 && ''${notification_normal} "''${new_selected}1 mounted" || ''${notification_normal} "Disk probably in use!"
          ;;
        esac
        ;;
      "  Unmount")
        new_selected=''$(printf '%s\n' "''${mounted_options[@]}" | ''${menu_alt} | awk '{print ''$1}')
        case ''$new_selected in
        "  Go back")
          menu_options usb
          ;;
        *)
          udisksctl unmount -b /dev/''${new_selected} && ''${notification_normal} "''$new_selected unmounted" || udisksctl unmount -b /dev/''${new_selected}1 && ''${notification_normal} "''${new_selected}1 unmounted" || ''${notification_normal} "Disk probably in use!"
          ;;
        esac
        ;;
      "  Go back")
        menu_options
        ;;
      esac

    }

    menu_updates() {

      options=("Edit Config" "Update Sources" "Build System" "  Go back")

      selected=''$(printf '%s\n' "''${options[@]}" | ''${menu_alt})

      case ''$selected in
      "Edit Config")
        ''$terminal -e bash -c "cd /home/falk/nixos-config && nvim"
        ;;
      "Update Sources")
        ''$terminal -e bash -c "nix flake update --flake /home/falk/nixos-config scripts && echo \"==> Completed\" || echo \"==> Failed\"; read -p \"Press Key to Exit\" ans"
        ;;
      "Build System")
        ''$terminal -e bash -c "sudo nixos-rebuild switch --flake /home/falk/nixos-config#''$(hostname) --impure && echo \"==> Completed\" || echo \"==> Failed\"; read -p \"Press Key to Exit\" ans"
        ;;
      "  Go back")
        menu_main
        ;;
      esac

    }

    case ''$1 in
    "wifi")
      menu_wifi
      ;;
    "blue")
      menu_blue
      ;;
    "vol")
      menu_vol
      ;;
    "mon")
      menu_mon
      ;;
    "tablet")
      menu_tablet
      ;;
    "light")
      menu_light
      ;;
    "energy")
      menu_energy
      ;;
    "theme")
      menu_theme
      ;;
    "usb")
      menu_usb
      ;;
    "updates")
      menu_updates
      ;;
    *)
      menu_main
      ;;
    esac

    # 󰟵    󰤫 󰤯 󰂯 󰕾 󰍹 󰓶   󰐦   󱊞      󰾰 󰂱 󰂯 󰂲 󰂰 󰓃    󰸈 󰋫 󰈙 󰕓 
  '';
}
