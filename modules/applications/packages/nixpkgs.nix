{
  lib,
  config,
  pkgs,
  nixpkgs-unstable,
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
          default = lib.mkEnableOption "Enables unstable-system-pkgs";
          base = lib.mkEnableOption "Enables unstable-base-pkgs";
          lang = lib.mkEnableOption "Enables unstable-lang-pkgs";
          tool = lib.mkEnableOption "Enables unstable-tool-pkgs";
          hypr = lib.mkEnableOption "Enables unstable-hypr-pkgs";
          desk = lib.mkEnableOption "Enables unstable-desk-pkgs";
          power = lib.mkEnableOption "Enables unstable-power-pkgs";
        };
        user.default = lib.mkEnableOption "Enables unstable-user-pkgs";
        font.default = lib.mkEnableOption "Enables unstable-font-pkgs";
      };
      unstable = {
        system.default = lib.mkEnableOption "Enables stable-system-pkgs";
        user.default = lib.mkEnableOption "Enables stable-user-pkgs";
        font.default = lib.mkEnableOption "Enables stable-font-pkgs";
      };
    };
  };

  config =
    let
      stable-base-pkgs = with pkgs; [
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

      stable-lang-pkgs = with pkgs; [
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

      stable-hypr-pkgs = with pkgs; [
        hyprshade
        xdg-desktop-portal-hyprland
        rofi-wayland
        swww
        dunst
        nwg-look
        whitesur-cursors
        bibata-cursors

        slurp
        feh
        grim
        swappy

        zathura
        pandoc

        hyprpicker
      ];

      stable-tool-pkgs = with pkgs; [
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

      stable-desk-pkgs = with pkgs; [
        waybar
        discord
        libreoffice-still
        arduino-ide
        freecad-wayland
        telegram-desktop
        orca-slicer
        rnote
        vlc
        remnote
        tor-browser-bundle-bin
      ];

      stable-power-pkgs = with pkgs; [
        furmark
        powertop
        ncdu
        htop
        powerstat
        tlp
        stress-ng
        auto-cpufreq
      ];

      stable-system-pkgs = with pkgs; [
      ];

      unstable-system-pkgs = with nixpkgs-unstable; [
      ];

      stable-user-pkgs = with pkgs; [
      ];

      unstable-user-pkgs = with nixpkgs-unstable; [ ];

      stable-font-pkgs = with pkgs; [
        nerd-fonts.ubuntu-mono
        nerd-fonts.fira-code
        nerd-fonts.hack
        nerd-fonts.roboto-mono
      ];

      unstable-font-pkgs = with nixpkgs-unstable; [ ];

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
