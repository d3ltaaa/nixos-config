{ ... }:
{
  # graphic backend for notifications
  programs.nixvim = {
    plugins.notify = {
      enable = true;
    };
  };
}
