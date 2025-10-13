{ ... }:
{
  # blink.cmp is a completion plugin with support for LSPs, cmdline, signature help, and snippets
  programs.nixvim = {
    plugins.blink-cmp = {
      enable = true;
      setupLspCapabilities = true;
      settings = {
        appearance = {
          nerd_font_variant = "normal";
          use_nvim_cmp_as_default = true;
        };
        completion = {
          accept = {
            auto_brackets = {
              enabled = true;
              semantic_token_resolution = {
                enabled = false;
              };
            };
          };
          documentation = {
            auto_show = true;
          };
        };
        keymap = {
          preset = "enter";
        };
        signature = {
          enabled = true;
        };
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
            # "luasnip"
          ];
        };
      };
    };
  };
}
