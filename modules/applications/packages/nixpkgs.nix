{
  lib,
  config,
  pkgs,
  pkgs-alt,
  ...
}:
{
  options = {
    applications.packages.nixpkgs = {
      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.pkgs;
        default = [ ];
      };
      pkgs = {
        system = {
          default = lib.mkEnableOption "Enables system-pkgs";
          base = lib.mkEnableOption "Enables base-pkgs";
          lang = lib.mkEnableOption "Enables lang-pkgs";
          tool = lib.mkEnableOption "Enables tool-pkgs";
          hypr = lib.mkEnableOption "Enables hypr-pkgs";
          desk = lib.mkEnableOption "Enables desk-pkgs";
          power = lib.mkEnableOption "Enables power-pkgs";
        };
        user.default = lib.mkEnableOption "Enables user-pkgs";
        font.default = lib.mkEnableOption "Enables font-pkgs";
      };
      pkgs-alt = {
        system.default = lib.mkEnableOption "Enables alt-system-pkgs";
        user.default = lib.mkEnableOption "Enables alt-user-pkgs";
        font.default = lib.mkEnableOption "Enables alt-font-pkgs";
      };
    };
  };

  config =
    let
      base-pkgs = with pkgs; [
        bat
        bat-extras.batman
        wget
        unzip
        tldr
        ripgrep
        rsync
        fzf
        man-db
        docker
        zsh
        zsh-syntax-highlighting
        starship
        git-credential-manager
        lazygit
        fastfetch
      ];

      lang-pkgs = with pkgs; [
        clang
        cmake
        meson
        rustup
        cpio
        pkg-config
        pyenv
        bc
        font-awesome
        psutils
      ];

      hypr-pkgs = with pkgs; [
        hyprshade
        rofi
        waypaper
        # hyprpaper
        swww
        dunst
        nwg-look
        whitesur-cursors
        bibata-cursors

        slurp
        feh
        grim
        swappy
        pinta

        zathura
        pandoc

        hyprpicker
      ];

      tool-pkgs = with pkgs; [
        mpv
        yt-dlg

        sox # ?
        ffmpeg_4 # ?

        android-tools

        upower
        pulsemixer
        libpulseaudio
        pavucontrol
        impala
        bluetui

        busybox
        dnsutils
        ethtool
        netcat-openbsd
      ];

      desk-pkgs = with pkgs; [
        waybar
        discord
        arduino-ide
        telegram-desktop
        vlc
        remnote
        tor-browser-bundle-bin
        bottles
      ];

      power-pkgs = with pkgs; [
        furmark
        powertop
        ncdu
        htop
        powerstat
        tlp
        stress-ng
        auto-cpufreq
      ];

      system-pkgs = with pkgs; [
        libreoffice
        xdg-desktop-portal-hyprland
      ];

      alt-system-pkgs = with pkgs-alt; [
        freecad-wayland
        orca-slicer
      ];

      user-pkgs = with pkgs; [
      ];

      alt-user-pkgs = with pkgs-alt; [ ];

      font-pkgs = with pkgs; [
        nerd-fonts.ubuntu-mono
        nerd-fonts.fira-code
        nerd-fonts.hack
        nerd-fonts.roboto-mono
      ];

      alt-font-pkgs = with pkgs-alt; [ ];

      cfg = config.applications.packages.nixpkgs;
    in
    {
      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      # Install system packages
      environment.systemPackages =
        [ ]
        ++ cfg.extraPackages
        ++ (pkgs.lib.optionals cfg.pkgs.system.default system-pkgs)
        ++ (pkgs.lib.optionals cfg.pkgs.system.base base-pkgs)
        ++ (pkgs.lib.optionals cfg.pkgs.system.lang lang-pkgs)
        ++ (pkgs.lib.optionals cfg.pkgs.system.tool tool-pkgs)
        ++ (pkgs.lib.optionals cfg.pkgs.system.hypr hypr-pkgs)
        ++ (pkgs.lib.optionals cfg.pkgs.system.desk desk-pkgs)
        ++ (pkgs.lib.optionals cfg.pkgs.system.power power-pkgs)
        ++ (pkgs.lib.optionals cfg.pkgs-alt.system.default alt-system-pkgs);

      # Install user packages
      users.users.${config.system.user.general.primary}.packages =
        [ ]
        ++ (pkgs.lib.optionals cfg.pkgs.user.default user-pkgs)
        ++ (pkgs.lib.optionals cfg.pkgs-alt.user.default alt-user-pkgs);
      # Install font packages
      fonts.packages =
        [ ]
        ++ (pkgs.lib.optionals cfg.pkgs.font.default font-pkgs)
        ++ (pkgs.lib.optionals cfg.pkgs-alt.font.default alt-font-pkgs);
    };
}
