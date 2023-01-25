# Config for GTK, QT, icons and cursor themes
{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.syu.theming;
in
{
  options.syu.theming = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.pointerCursor = {
      x11.enable = true;
      package = pkgs.breezex-cursor;
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
        package = pkgs.breezex-cursor;
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
  };
}
