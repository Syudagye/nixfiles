{ config, pkgs, breezex-cursor, ... }:
{
  home.
  pointerCursor = {
    x11.enable = true;
    package = breezex-cursor;
    name = "BreezeX-Dark";
    size = 28;
  };
  gtk = {
    enable = true;
    # cursorTheme.package = pkgs.libsForQt5.breeze-gtk;
    theme = {
      name = "vimix-dark-compact-amethyst";
      package = pkgs.vimix-gtk-themes;
    };
    cursorTheme = {
      name = "BreezeX-Dark";
      package = breezex-cursor;
    };
    iconTheme = {
      name = "Vimix-Amethyst-dark";
      package = pkgs.vimix-icon-theme;
    };
  };
  qt = {
    enable = true;
    platformTheme = "gtk";
  };
}
