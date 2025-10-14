{ ... }:
{
  # notifications
  programs.nixvim = {
    plugins.noice = {
      enable = true;
      settings = {
        notify = {
          enabled = false;
          view = "notify";
        };
        messages = {
          enabled = true;
          view = "notify";
        };
        lsp = {
          message = {
            enabled = true;
            view = "notify";
          };
          progress = {
            enabled = false;
            view = "notify";
          };
        };
        popupmenu = {
          enabled = true;
          backend = "nui";
        };
      };
    };
  };
}
