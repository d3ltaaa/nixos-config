{ ... }:
{
  # graphic backend
  programs.nixvim = {
    plugins.nui = {
      enable = true;
    };
  };
}
