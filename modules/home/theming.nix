# Config for GTK, QT, icons and cursor themes
{
  lib,
  pkgs,
  config,
  ...
}:

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
        name = "Nordic";
        package = pkgs.nordic;
      };
      cursorTheme = {
        name = "BreezeX-Dark";
        package = pkgs.breezex-cursor;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-nord;
      };
    };
    qt = {
      enable = true;
      style = {
        package = pkgs.nordic;
        name = "Nordic";
      };
    };
  };
}
