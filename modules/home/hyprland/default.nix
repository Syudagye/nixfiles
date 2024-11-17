# HYPRLAND !!!
{
  lib,
  pkgs,
  config,
  ...
}@inputs:

with lib;
let
  cfg = config.syu.hyprland;
in
{
  options.syu.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    config = mkOption {
      type = types.path;
      default = ./hyprland.conf;
    };
  };

  config.home = mkIf cfg.enable {
    file.".config/hypr/hyprland.conf".source = cfg.config;
    file.".config/wpaperd".source = ./wpaperd;
  };
}
