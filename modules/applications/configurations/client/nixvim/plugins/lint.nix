{ ... }:
{
  # linting
  programs.nixvim = {
    plugins.lint = {
      enable = true;
    };
  };
}
