{ ... }:
{
  programs.nixvim = {
    plugins.flash.enable = true;
    keymaps = [
      {
        key = "s";
        action.__raw = ''function() require'flash'.jump({}) end'';
        options.desc = "Flash search";
        options.remap = true;
      }
    ];
  };
}
