{ pkgs, config }:
pkgs.writeShellApplication {
  name = "menu_options";
  runtimeInputs = with pkgs; [
    impala
    bluetui
    pulsemixer
  ];
  text =
    let
      cfg-components = config.system.desktop.components;
      cfg-applications = config.applications.configurations.client;
      menu =
        if cfg-components.rofi.enable then
          "${pkgs.rofi-wayland}/bin/rofi -dmenu -i -theme-str '@import \"settings\"'"
        else
          "";
      terminal = if cfg-applications.foot.enable then "${pkgs.foot}/bin/foot" else "";
      terminal_floating =
        if cfg-applications.foot.enable then "${pkgs.foot}/bin/foot --app-id \"FLOATING-SETTINGS\"" else "";
      edit_monitors_cmd =
        if
          (
            config.system.desktop.desktop-environments.niri-desktop.enable
            && (cfg-applications.neovim.nixvim.enable || cfg-applications.neovim.nvf.enable)
          )
        then
          "${pkgs.foot}/bin/foot --app-id \"FLOATING-SETTINGS\" -e nvim ~/.config/niri/config.kdl"
        else if config.system.desktop.desktop-environments.hyprland-desktop.enable then
          "hyprctl dispatch exec \"[float;size 1000 700] nwg-displays\""
        else
          "";
    in
    ''
      menu_main() {
        # Define first layer
        options=(" Wifi" "󰂯 Bluetooth" "󰕾 Audio" "󰍹 Monitors" " Wallpaper" " Light" "󰓅 Energy" " Nixos Config" "󰅙 Close")

        # display options
        selected=''$(printf '%s\n' "''${options[@]}" | ${menu} -p " Settings")

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
        "󰓅 Energy")
          menu_energy
          ;;
        " Nixos Config")
          menu_updates
          ;;
        "󰅙 Close") ;;
        esac
      }

      menu_wifi() {
        ${terminal_floating} impala
      }

      menu_blue() {
        ${terminal_floating} bluetui
      }

      menu_vol() {
        ${terminal_floating} pulsemixer
      }

      menu_mon() {
        ${edit_monitors_cmd}
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
        selected=''$(printf '%s\n' "''${options[@]}" | ${menu} -p " Light")

        case "''$selected" in
        "  Brightness")
          while true; do
            options=("  +10%" "  -10%" "  Max Brightness" "  Lowest Brightness" "  Go back")
            further_selected=''$(printf '%s\n' "''${options[@]}" | ${menu} -p "Brightness:")
            case "''$further_selected" in
            "  +10%")
              script_light up
              ;;
            "  -10%")
              script_light down
              ;;
            "  Max Brightness")
              script_light day
              ;;
            "  Lowest Brightness")
              script_light night
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
            further_selected=''$(printf '%s\n' "''${options[@]}" | ${menu} -p "Blue light:")
            case "''$further_selected" in
            "  Blue-light-filter off")
              script_light blue
              ;;
            "  Blue-light-filter on")
              script_light red
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
          menu_options main
          ;;
        esac

      }

      menu_energy() {
        options=("  Reset" "󱧥  Powersave" "󰓅  Performance" "  Go back")

        # Use dmenu to display the options and prompt the user to select one
        selected=''$(printf '%s\n' "''${options[@]}" | ${menu} -p "󰓅 Energy")

        # Depending on which option was selected, perform the corresponding system action
        case ''$selected in
        "  Reset")  pkexec auto-cpufreq --force reset ;;
        "󱧥  Powersave") pkexec auto-cpufreq --force powersave ;;
        "󰓅  Performance")  pkexec auto-cpufreq --force performance ;;
        "  Go back") menu_main ;;
        esac
      }

      menu_updates() {

        options=("Edit Config" "Update Sources" "Build System" "  Go back")

        selected=''$(printf '%s\n' "''${options[@]}" | ${menu} -p " Nixos Config")

        case ''$selected in
        "Edit Config")
          ${terminal} -e bash -c "cd ''$HOME/nixos-config && nvim"
          ;;
        "Update Sources")
          ${terminal} -e bash -c "nix flake update --flake ''$HOME/nixos-config scripts && echo \"==> Completed\" || echo \"==> Failed\"; read -p \"Press Key to Exit\" ans"
          ;;
        "Build System")
          ${terminal} -e bash -c "sudo nixos-rebuild switch --flake ''$HOME/nixos-config#''$(hostname) --impure && echo \"==> Completed\" || echo \"==> Failed\"; read -p \"Press Key to Exit\" ans"
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
      "light")
        menu_light
        ;;
      "energy")
        menu_energy
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
