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
      theme = {
        name = "Breeze-Dark";
        package = pkgs.libsForQt5.breeze-gtk;
      };
      cursorTheme = {
        name = "BreezeX-Dark";
        package = pkgs.breezex-cursor;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };
    qt = {
      enable = true;
      style = {
        package = pkgs.libsForQt5.breeze-qt5;
        name = "Breeze-Dark";
      };
    };
  };
}
