{ lib, config, ... }:
{
  xdg.desktopEntries.nvim = lib.mkForce {
    name = "Neovim wrapper";
    genericName = "Text Editor";
    comment = "Edit text files";
    # TryExec = "nvim";
    exec = "foot nvim %F";
    type = "Application";
    # Keywords = "Text;editor";
    icon = "nvim";
    categories = [
      "X-utilities"
      "TextEditor"
    ];
    startupNotify = false;
    terminal = false;
    mimeType = [
      "text/english"
      "text/plain"
      "text/x-makefile"
      "text/x-c++hdr"
      "text/x-c++src"
      "text/x-chdr"
      "text/x-csrc"
      "text/x-java"
      "text/x-moc"
      "text/x-pascal"
      "text/x-tcl"
      "text/x-tex"
      "application/x-shellscript"
      "text/x-c"
      "text/x-c++"
    ];
  };
}
