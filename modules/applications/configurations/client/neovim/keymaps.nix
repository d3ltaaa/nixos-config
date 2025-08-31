{ ... }:
{
  programs.nixvim = {
    globals.mapleader = " ";

    keymaps = [
      # Windows
      {
        mode = "n";
        key = "<leader>nh";
        action = ":nohl<CR>";
        options.desc = "Remove Highlights";
      }
      {
        mode = "n";
        key = "<leader>wv";
        action = "<C-w>v";
        options.desc = "Split window vertically";
      }
      {
        mode = "n";
        key = "<leader>wh";
        action = "<C-w>s";
        options.desc = "Split window horizontally";
      }
      {
        mode = "n";
        key = "<leader>wx";
        action = ":close<CR>";
        options.desc = "Close window";
      }
      {
        mode = "n";
        key = "<leader>H";
        action = "<C-w>h";
        options.desc = "Move left";
      }
      {
        mode = "n";
        key = "<leader>L";
        action = "<C-w>l";
        options.desc = "Move right";
      }
      {
        mode = "n";
        key = "<leader>J";
        action = "<C-w>j";
        options.desc = "Move down";
      }
      {
        mode = "n";
        key = "<leader>K";
        action = "<C-w>k";
        options.desc = "Move up";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<cmd>resize +2<cr>";
        options.desc = "Increase window height";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<cmd>resize -2<cr>";
        options.desc = "Decrease window height";
      }
      {
        mode = "n";
        key = "<C-h>";
        action = "<cmd>vertical resize +2<cr>";
        options.desc = "Increase window windth";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<cmd>vertical resize -2<cr>";
        options.desc = "Decrease window windth";
      }
      {
        mode = "n";
        key = "<leader>tn";
        action = ":tabnew<CR>";
        options.desc = "New tab";
      }
      {
        mode = "n";
        key = "<leader>tx";
        action = ":tabclose<CR>";
        options.desc = "Close tab";
      }
      {
        mode = "n";
        key = "<leader>I";
        action = ":tabp<CR>";
        options.desc = "Left tab";
      }
      {
        mode = "n";
        key = "<leader>O";
        action = ":tabn<CR>";
        options.desc = "Right tab";
      }
    ];
  };
}
