{ lib, config, ... }:
{
  options = {
    applications.configurations.client.neovim.enable = lib.mkEnableOption "Enables neovim module";
  };
  config =
    let
      cfg = config.applications.configurations.client.neovim;
    in
    lib.mkIf cfg.enable {
      environment.variables = {
        EDITOR = "nvim";
        ELECTRON_OZONE_PLATFORM_HINT = "auto"; # TODO does that belong here?
        WLR_RENDERER_ALLOW_SOFTWARE = 1;
      };

      security.sudo.extraConfig = "Defaults        !sudoedit_checkdir"; # for neovim + lf with root owned files

      # Home Manager as NixOS module
      home-manager.users.${config.system.user.general.primary} =
        { config, ... }:
        {
          imports = [
            ./settings.nix
            ./keymaps.nix
            ./desktop.nix
            # ./plugins/cmp.nix
            ./plugins/icons.nix
            ./plugins/telescope.nix
            ./plugins/themes.nix
            ./plugins/conform.nix
            ./plugins/blink-cmp.nix
            ./plugins/bufferline.nix
            ./plugins/flash.nix
            ./plugins/neo-tree.nix
            ./plugins/treesitter.nix
            ./plugins/lsp.nix
            ./plugins/which-key.nix
            ./plugins/noice.nix
            ./plugins/lint.nix
            ./plugins/trouble.nix
            ./plugins/mini.nix
            ./plugins/colorizer.nix
          ];
        };
    };
}
