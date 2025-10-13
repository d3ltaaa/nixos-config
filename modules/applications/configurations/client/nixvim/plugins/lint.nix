{ pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = with pkgs; [
      clang-tools
      ruff
      eslint_d
      gitlint
      golangci-lint
      statix
      yamllint
    ];
    plugins.lint = {
      enable = true;
      lintersByFt = {
        c = [ "clangtidy" ];
        cpp = [ "clangtidy" ];
        css = [ "eslint_d" ];
        gitcommit = [ "gitlint" ];
        go = [ "golangcilint" ];
        javascript = [ "eslint_d" ];
        javascriptreact = [ "eslint_d" ];
        json = [ "jsonlint" ];
        lua = [ "luacheck" ];
        markdownlint = [ "markdownlint" ];
        nix = [ "statix" ];
        python = [ "ruff" ];
        sh = [ "shellcheck" ];
        typescript = [ "eslint_d" ];
        typescriptreact = [ "eslint_d" ];
        yaml = [ "yamllint" ];
      };
    };
  };
}
