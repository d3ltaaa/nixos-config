{ config, ... }:
{
  # themes
  programs.nixvim = {
    colorschemes = {
      catppuccin = {
        # palette = {
        #   base00 = "1e2030"; # #1e2030 default background
        #   base01 = "24273a"; # #24273a lighter background (status bars, line numbers, folding marks)
        #   base02 = "363a4f"; # #363a4f selection background
        #   base03 = "494d64"; # #494d64 comments, invisibles, line highlighting
        #   base04 = "5b6078"; # #5b6078 dark foreground
        #   base05 = "ffffff"; # #ffffff default foreground, delimiters, operators
        #   base06 = "cad3f5"; # #cad3f5 light foreground
        #   base07 = "b7bdf8"; # #b7bdf8 light background
        #   base08 = "ed8796"; # #ed8796 variables, xml tags, markup link text
        #   base09 = "f5a97f"; # #f5a97f integers, boolean, constants
        #   base0A = "eed49f"; # #eed49f classes, markup bold, search text background
        #   base0B = "a6da95"; # #a6da95 strings, inherited class, markup code
        #   base0C = "8bd5ca"; # #8bd5ca support, regular expressions, escape characters
        #   base0D = "8aadf4"; # #8aadf4 functions, methods, headings
        #   base0E = "c6a0f6"; # #c6a0f6 keywords, storage, selector
        #   base0F = "f0c6c6"; # #f0c6c6 deprecated
        # };
        enable = true;
        settings = {
          # background = {
          #   light = "macchiato";
          #   dark = "mocha";
          # };
          # Normal = { bg = "#${config.colorScheme.palette.base00}", fg = "#${config.colorScheme.palette.base05}" },
          # flavour = "frappe"; # "latte", "mocha", "frappe", "macchiato" or raw lua code
          no_bold = false;
          no_italic = false;
          no_underline = false;
          transparent_background = true;
          integrations = {
            cmp = true;
            notify = true;
            gitsigns = true;
            neotree = true;
            which_key = true;
            illuminate = {
              enabled = true;
              lsp = true;
            };
            navic = {
              enabled = true;
              custom_bg = "NONE";
            };
            treesitter = true;
            telescope.enabled = true;
            indent_blankline.enabled = true;
            mini = {
              enabled = true;
              indentscope_color = "rosewater";
            };
            native_lsp = {
              enabled = true;
              inlay_hints = {
                background = true;
              };
              virtual_text = {
                errors = [ "italic" ];
                hints = [ "italic" ];
                information = [ "italic" ];
                warnings = [ "italic" ];
                ok = [ "italic" ];
              };
              underlines = {
                errors = [ "underline" ];
                hints = [ "underline" ];
                information = [ "underline" ];
                warnings = [ "underline" ];
              };
            };
          };
          custom_highlights = ''
            function(colors)
              return {
                Normal = { fg = "#${config.colorScheme.palette.base05}" },
                NormalFloat = { fg = "#${config.colorScheme.palette.base05}", bg = "NONE"},
                Comment = { fg = "#${config.colorScheme.palette.base07}", style = { "italic" } },

                Constant = { fg = "#${config.colorScheme.palette.base09}" },
                String = { fg = "#${config.colorScheme.palette.base0B}" },
                Character = { fg = "#${config.colorScheme.palette.base0B}" },
                Number = { fg = "#${config.colorScheme.palette.base09}" },
                Boolean = { fg = "#${config.colorScheme.palette.base09}" },
                Float = { fg = "#${config.colorScheme.palette.base09}" },
                FloatBorder = { fg = "#${config.colorScheme.palette.base0D}", bg = "NONE" },
                FloatTitle = { fg = "#${config.colorScheme.palette.base0D}", bg = "NONE" },

                Identifier = { fg = "#${config.colorScheme.palette.base08}" },
                Function = { fg = "#${config.colorScheme.palette.base0D}" },

                Statement = { fg = "#${config.colorScheme.palette.base0E}" },
                Conditional = { fg = "#${config.colorScheme.palette.base0E}" },
                Repeat = { fg = "#${config.colorScheme.palette.base0E}" },
                Label = { fg = "#${config.colorScheme.palette.base0E}" },
                Operator = { fg = "#${config.colorScheme.palette.base05}" },
                Keyword = { fg = "#${config.colorScheme.palette.base0E}" },
                Exception = { fg = "#${config.colorScheme.palette.base08}" },

                PreProc = { fg = "#${config.colorScheme.palette.base0A}" },
                Include = { fg = "#${config.colorScheme.palette.base0D}" },
                Define = { fg = "#${config.colorScheme.palette.base0E}" },
                Macro = { fg = "#${config.colorScheme.palette.base0E}" },
                PreCondit = { fg = "#${config.colorScheme.palette.base0A}" },

                Type = { fg = "#${config.colorScheme.palette.base0A}" },
                StorageClass = { fg = "#${config.colorScheme.palette.base0E}" },
                Structure = { fg = "#${config.colorScheme.palette.base0A}" },
                Typedef = { fg = "#${config.colorScheme.palette.base0A}" },

                Special = { fg = "#${config.colorScheme.palette.base0C}" },
                SpecialChar = { fg = "#${config.colorScheme.palette.base0F}" },
                Tag = { fg = "#${config.colorScheme.palette.base08}" },
                Delimiter = { fg = "#${config.colorScheme.palette.base05}" },
                SpecialComment = { fg = "#${config.colorScheme.palette.base07}", style = { "italic" } },
                Debug = { fg = "#${config.colorScheme.palette.base08}" },

                Underlined = { fg = "#${config.colorScheme.palette.base0D}", style = { "underline" } },
                Ignore = { fg = "#${config.colorScheme.palette.base00}" },
                Error = { fg = "#${config.colorScheme.palette.base08}", bg = "#${config.colorScheme.palette.base00}", style = { "bold" } },
                Todo = { fg = "#${config.colorScheme.palette.base0A}", bg = "#${config.colorScheme.palette.base01}", style = { "bold" } },

                LineNr        = { fg = "#${config.colorScheme.palette.base06}" },
                CursorLineNr  = { fg = "#${config.colorScheme.palette.base05}", style = { "bold" } }, 
                VertSplit     = { fg = "#${config.colorScheme.palette.base05}" }, 
                NvimTreeVertSplit = { fg = "#${config.colorScheme.palette.base05}" }, 
                NvimTreeWinSeparator = { fg = "#${config.colorScheme.palette.base05}" }, 

                NeoTreeVertSplit = { fg = "#${config.colorScheme.palette.base05}" }, 
                NeoTreeStatusLineNC = { fg = "#${config.colorScheme.palette.base05}", bg = "NONE"},
                NeoTreeWinSeparator = { fg = "#${config.colorScheme.palette.base06}"},
                NeoTreeDimText = {fg = "#${config.colorScheme.palette.base06}"},
                NeoTreeDotfile = {fg = "#${config.colorScheme.palette.base07}"},
                NeoTreeMessage = {fg = "#${config.colorScheme.palette.base06}"},
                NeoTreeExpander = {fg = "#${config.colorScheme.palette.base07}"},
                NeoTreeFileStats = {fg = "#${config.colorScheme.palette.base07}"},
                NeoTreeFileStatsHeader = {fg = "#${config.colorScheme.palette.base0D}"},


                Added = { fg = "#${config.colorScheme.palette.base0B}" },
                Changed = { fg = "#${config.colorScheme.palette.base0A}" },
                Removed = { fg = "#${config.colorScheme.palette.base08}" },
                ["@comment"] = { fg = "#${config.colorScheme.palette.base05}", style = { "italic" } },
                ["@function"] = { fg = "#${config.colorScheme.palette.base0D}" },
                ["@keyword"] = { fg = "#${config.colorScheme.palette.base0E}" },
                ["@variable"] = { fg = "#${config.colorScheme.palette.base08}" },
              }
            end
          '';
        };
      };
    };
  };
}
