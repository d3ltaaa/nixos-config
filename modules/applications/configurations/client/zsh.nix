{ lib, config, ... }:
{
  options = {
    applications.configurations.zsh = {
      enable = lib.mkEnableOption "Enables Zsh module";
    };
  };

  config =
    let
      cfg = config.applications.configurations.zsh;
    in
    lib.mkIf cfg.enable {
      programs.zsh.enable = true;

      # Home Manager as NixOS module
      home-manager.users.${config.settings.users.primary} =
        { config, ... }:
        {
          programs.zsh = {
            enable = true;
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
            initContent = ''
              if pgrep -f Hyprland > /dev/null; then
                if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]]; then
              	tmux
                fi
              else
                Hyprland
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
