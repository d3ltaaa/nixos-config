{ lib, config, ... }:
{
  options = {
    applications.configurations.client.neovim.nixvim.enable =
      lib.mkEnableOption "Enables neovim module";
  };
  config =
    let
      cfg = config.applications.configurations.client.neovim.nixvim;
    in
    lib.mkIf cfg.enable {
      environment.variables = {
        EDITOR = "nvim";
      };

      security.sudo.extraConfig = "Defaults        !sudoedit_checkdir"; # for neovim + lf with root owned files

      # Home Manager as NixOS module
      home-manager.users.${config.system.user.general.primary} =
        { ... }:
        {
          imports = [
            ./settings.nix
            ./keymaps.nix
            ./desktop.nix
            ./plugins/cmp.nix
            ./plugins/icons.nix
            ./plugins/telescope.nix
            ./plugins/themes.nix
            ./plugins/conform.nix
            ./plugins/blink-cmp.nix
            ./plugins/bufferline.nix
            ./plugins/flash.nix
            ./plugins/statusline.nix
            ./plugins/neo-tree.nix
            ./plugins/smear-cursor.nix
            ./plugins/tiny-inline-diagnostic.nix
            ./plugins/treesitter.nix
            ./plugins/lint.nix
            ./plugins/lsp.nix
            ./plugins/which-key.nix
            ./plugins/noice.nix
            ./plugins/trouble.nix
            ./plugins/mini.nix
            ./plugins/colorizer.nix
          ];
        };
    };
}
