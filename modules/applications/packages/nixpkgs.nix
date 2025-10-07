{
  lib,
  config,
  pkgs,
  nixpkgs-stable,
  ...
}:
{
  options = {
    applications.packages.nixpkgs = {
      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.pkgs;
        default = [ ];
      };
      stable = {
        system = {
          default = lib.mkEnableOption "Enables stable-system-pkgs";
          base = lib.mkEnableOption "Enables stable-base-pkgs";
          lang = lib.mkEnableOption "Enables stable-lang-pkgs";
          tool = lib.mkEnableOption "Enables stable-tool-pkgs";
          hypr = lib.mkEnableOption "Enables stable-hypr-pkgs";
          desk = lib.mkEnableOption "Enables stable-desk-pkgs";
          power = lib.mkEnableOption "Enables stable-power-pkgs";
        };
        user.default = lib.mkEnableOption "Enables stable-user-pkgs";
        font.default = lib.mkEnableOption "Enables stable-font-pkgs";
      };
      unstable = {
        system.default = lib.mkEnableOption "Enables unstable-system-pkgs";
        user.default = lib.mkEnableOption "Enables unstable-user-pkgs";
        font.default = lib.mkEnableOption "Enables unstable-font-pkgs";
      };
    };
  };

  config =
    let
      stable-base-pkgs = with nixpkgs-stable; [
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

      stable-lang-pkgs = with nixpkgs-stable; [
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

      stable-hypr-pkgs = with nixpkgs-stable; [
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

      stable-tool-pkgs = with nixpkgs-stable; [
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

      stable-desk-pkgs = with nixpkgs-stable; [
        waybar
        discord
        libreoffice-still
        arduino-ide
        freecad
        telegram-desktop
        orca-slicer
        vlc
        remnote
        tor-browser-bundle-bin
        bottles
      ];

      stable-power-pkgs = with nixpkgs-stable; [
        furmark
        powertop
        ncdu
        htop
        powerstat
        tlp
        stress-ng
        auto-cpufreq
      ];

      stable-system-pkgs = with nixpkgs-stable; [
      ];

      unstable-system-pkgs = with pkgs; [
        xdg-desktop-portal-hyprland
        rnote
      ];

      stable-user-pkgs = with nixpkgs-stable; [
      ];

      unstable-user-pkgs = with pkgs; [ ];

      stable-font-pkgs = with nixpkgs-stable; [
        nerd-fonts.ubuntu-mono
        nerd-fonts.fira-code
        nerd-fonts.hack
        nerd-fonts.roboto-mono
      ];

      unstable-font-pkgs = with pkgs; [ ];

      cfg = config.applications.packages.nixpkgs;
    in
    {
      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      # Install system packages
      environment.systemPackages =
        [ ]
        ++ cfg.extraPackages
        ++ (pkgs.lib.optionals cfg.stable.system.default stable-system-pkgs)
        ++ (pkgs.lib.optionals cfg.stable.system.base stable-base-pkgs)
        ++ (pkgs.lib.optionals cfg.stable.system.lang stable-lang-pkgs)
        ++ (pkgs.lib.optionals cfg.stable.system.tool stable-tool-pkgs)
        ++ (pkgs.lib.optionals cfg.stable.system.hypr stable-hypr-pkgs)
        ++ (pkgs.lib.optionals cfg.stable.system.desk stable-desk-pkgs)
        ++ (pkgs.lib.optionals cfg.stable.system.power stable-power-pkgs)
        ++ (pkgs.lib.optionals cfg.unstable.system.default unstable-system-pkgs);

      # Install user packages
      users.users.${config.system.user.general.primary}.packages =
        [ ]
        ++ (pkgs.lib.optionals cfg.stable.user.default stable-user-pkgs)
        ++ (pkgs.lib.optionals cfg.unstable.user.default unstable-user-pkgs);
      # Install font packages
      fonts.packages =
        [ ]
        ++ (pkgs.lib.optionals cfg.stable.font.default stable-font-pkgs)
        ++ (pkgs.lib.optionals cfg.unstable.font.default unstable-font-pkgs);
    };
}
