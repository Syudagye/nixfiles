# HYPRLAND !!!
{ lib, pkgs, config, ... } @ inputs:

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
    installWithNix = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config.home = mkIf (cfg.enable && !cfg.installWithNix) {
    file.".config/hypr/hyprland.conf".source = cfg.config;
  };

  config.wayland.windowManager.hyprland = mkIf (cfg.enable && cfg.installWithNix) {
    inherit (cfg) enable;
    recommendedEnvironment = true;
  };
}
