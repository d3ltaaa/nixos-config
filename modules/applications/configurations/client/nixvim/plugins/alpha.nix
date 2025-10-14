{ ... }:
{
  # dashboard
  programs.nixvim = {
    plugins = {
      alpha = {
        enable = true;
        layout = [
          {
            type = "padding";
            val = 6;
          }
          {
            type = "text";
            val = [
              ''_____   __                                       ''
              ''___  | / /_____ ______ ___   _____(_)_______ ___ ''
              ''__   |/ / _  _ \_  __ \__ | / /__  / __  __ `__ \''
              ''_  /|  /  /  __// /_/ /__ |/ / _  /  _  / / / / /''
              ''/_/ |_/   \___/ \____/ _____/  /_/   /_/ /_/ /_/ ''
            ];
            opts = {
              position = "center";
              hl = "Type";
            };
          }
          {
            type = "padding";
            val = 4;
          }
          {
            type = "group";
            val = [
              {
                type = "button";
                val = "      New File    ";
                on_press.__raw = "function() vim.cmd[[ene]] end";
                opts = {
                  shortcut = "n";
                  keymap = [
                    "n"
                    "n"
                    "<cmd>ene<CR>"
                    {
                      noremap = true;
                      silent = true;
                      nowait = true;
                    }
                  ];
                  position = "center";
                  width = 50;
                  align_shortcut = "right";
                  hl_shortcut = "Keyword";
                };
              }
              {
                type = "padding";
                val = 2;
              }
              {
                type = "button";
                val = "      Find File    ";
                on_press.__raw = "function() require('telescope.builtin').find_files() end";
                opts = {
                  shortcut = "f";
                  keymap = [
                    "n"
                    "f"
                    "<cmd>lua require('telescope.builtin').find_files()<CR>"
                    {
                      noremap = true;
                      silent = true;
                      nowait = true;
                    }
                  ];
                  position = "center";
                  width = 50;
                  align_shortcut = "right";
                  hl_shortcut = "Keyword";
                };
              }
              {
                type = "padding";
                val = 2;
              }
              {
                type = "button";
                val = "      Recent Files    ";
                on_press.__raw = "function() require('telescope.builtin').oldfiles() end";
                opts = {
                  shortcut = "r";
                  keymap = [
                    "n"
                    "r"
                    "<cmd>lua require('telescope.builtin').oldfiles()<CR>"
                    {
                      noremap = true;
                      silent = true;
                      nowait = true;
                    }
                  ];
                  position = "center";
                  width = 50;
                  align_shortcut = "right";
                  hl_shortcut = "Keyword";
                };
              }
              {
                type = "padding";
                val = 2;
              }
              {
                type = "button";
                val = "      Find Text    ";
                on_press.__raw = "function() require('telescope.builtin').live_grep() end";
                opts = {
                  shortcut = "g";
                  keymap = [
                    "n"
                    "g"
                    "<cmd>lua require('telescope.builtin').live_grep()<CR>"
                    {
                      noremap = true;
                      silent = true;
                      nowait = true;
                    }
                  ];
                  position = "center";
                  width = 50;
                  align_shortcut = "right";
                  hl_shortcut = "Keyword";
                };
              }
              {
                type = "padding";
                val = 2;
              }
              {
                type = "button";
                val = "      Quit Neovim    ";
                on_press.__raw = "function() vim.cmd[[qa]] end";
                opts = {
                  shortcut = "q";
                  keymap = [
                    "n"
                    "q"
                    "<cmd>qa<CR>"
                    {
                      noremap = true;
                      silent = true;
                      nowait = true;
                    }
                  ];
                  position = "center";
                  width = 50;
                  align_shortcut = "right";
                  hl_shortcut = "Keyword";
                };
              }
            ];
          }
        ];
      };
    };
  };
}
