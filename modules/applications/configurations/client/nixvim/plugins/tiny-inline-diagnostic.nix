{ ... }:
{
  # gui tab implementation
  programs.nixvim = {
    plugins.tiny-inline-diagnostic = {
      enable = true;
      settings = {
        multilines = {
          enabled = true;
        };
        options = {
          use_icons_from_diagnostic = true;
        };
        preset = "classic";
        virt_texts = {
          priority = 2048;
        };
      };
    };
  };
}
