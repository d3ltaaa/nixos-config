{ ... }:
{
  # gui tab implementation
  programs.nixvim = {
    plugins.lualine.enable = true;
  };
}
