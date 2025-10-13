{ lib, config, ... }:
{
  options = {
    applications.configurations.client.neovim.nvf.enable = lib.mkEnableOption "Enables neovim module";
  };
  config =
    let
      cfg = config.applications.configurations.client.neovim.nvf;
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
          vim = {
            theme = {
              enable = true;
              name = "gruvbox";
              style = "dark";
            };
            statusline.lualine.enable = true;
            telescope.enable = true;
            autocomplete.nvim-cmp.enable = true;
            languages = {
              enableLSP = true;
              enableTreesitter = true;
              nix.enable = true;
              ts.enable = true;
              rust.enable = true;
            };
          };
          imports = [
          ];
        };
    };
}
