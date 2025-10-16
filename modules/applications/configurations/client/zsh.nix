{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configurations.client.zsh = {
      enable = lib.mkEnableOption "Enables Zsh module";
    };
  };

  config =
    let
      cfg = config.applications.configurations.client.zsh;
    in
    lib.mkIf cfg.enable {
      programs.zsh.enable = true;

      # Home Manager as NixOS module
      home-manager.users.${config.system.user.general.primary} =
        { ... }:
        let
          nixos-config = config;
        in
        {
          programs.zsh = {
            enable = true;
            package = pkgs.zsh;
            enableCompletion = true;
            enableVteIntegration = true;
            autosuggestion.enable = true;
            autosuggestion.strategy = [
              "history"
              "completion"
              "match_prev_cmd"
            ];
            defaultKeymap = "viins";
            shellAliases = {
              "lss" = "ls -lA --color=auto";
              "ls" = "ls -1 --color=auto";
              "grep" = "grep --color=auto";
              "v" = "nvim";
              "build" = "cd ~/flakes/ && sudo nixos-rebuild switch --flake #.T440P";
              "cat" = "bat -p";
              "man" = "batman";
            };
            completionInit = ''
              autoload -U compinit
              zstyle ':completion:*' menu select
              zmodload zsh/complist
              compinit
              _comp_options+=(globdots)		# Include hidden files.
            '';
            syntaxHighlighting.enable = true;
            history.save = 1000;
            history.size = 1000;
            history.share = true;
            # viMode = true;
            initContent =
              let
                tmuxCheck = lib.optionalString nixos-config.applications.configurations.client.tmux.enable ''
                  if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]]; then
                    tmux
                  fi
                '';

                hyprlandLaunch = "Hyprland";

                niriLaunch = "niri";

                yaziFunction = lib.optionalString nixos-config.applications.configurations.client.yazi.enable ''
                  function y() {
                    	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
                    	yazi "$@" --cwd-file="$tmp"
                    	IFS= read -r -d \'\' cwd < "$tmp"
                    	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
                    	rm -f -- "$tmp"
                  }
                '';
              in
              ''
                ${yaziFunction}

                if pgrep -f ${hyprlandLaunch} > /dev/null; then
                  ${tmuxCheck}
                elif pgrep  -f ${niriLaunch} > /dev/null; then
                  ${tmuxCheck}
                else
                  if command -v ${hyprlandLaunch} > /dev/null; then  
                    ${hyprlandLaunch}
                  elif command -v ${niriLaunch} > /dev/null; then 
                    ${niriLaunch}-session
                  fi
                fi
              '';
          };
          programs.starship = {
            enable = true;
            enableBashIntegration = true;
            enableZshIntegration = true;
            settings = {

            };
          };
          # environment.pathsToLink = [ "/share/zsh" ];
        };
    };
}
