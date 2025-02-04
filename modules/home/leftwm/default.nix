# LeftWM and LeftHK
{
  lib,
  pkgs,
  config,
  leftwm,
  lefthk,
  ...
}@inputs:

with lib;
let
  cfg = config.syu.leftwm;
  modularConfigs = import ./config.nix pkgs;
in
{
  options.syu.leftwm = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    theme = mkOption {
      type = types.path;
      default = ./themes/fancy-toaster;
    };
    config = mkOption {
      type = types.nullOr types.path;
      default = null;
    };
    lefthk = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      laptop = mkOption {
        type = types.bool;
        default = false;
      };
    };
    installPackages = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config.home = mkIf cfg.enable ({
    packages =
      with pkgs;
      [ (mkIf cfg.installPackages leftwm.packages.${pkgs.system}.leftwm) ]

      # import the theme
      ++ (import (cfg.theme + /deps.nix)) inputs

      # setup lefthk
      ++ (
        if cfg.lefthk.enable then
          [
            (mkIf cfg.installPackages lefthk.packages.${pkgs.system}.lefthk)

            xclip
            maim
            ((import ./scripts/volume.nix) pkgs)
          ]
          # laptop specific config
          ++ (
            if cfg.lefthk.laptop then
              [
                ((import ./scripts/brightness.nix) pkgs)
                bc
                brightnessctl
              ]
            else
              [ ]
          )
        else
          [ ]
      );

    file =
      (
        # Modular config
        if cfg.config == null then
          {
            ".config/leftwm/azerty.ron".source = modularConfigs.azerty;
            ".config/leftwm/ergol.ron".source = modularConfigs.ergol;
            # ".config/leftwm/up" = {
            #   source = modularConfigs.upscript;
            #   executable = true;
            # };
            # ".config/leftwm/down" = {
            #   source = modularConfigs.downscript;
            #   executable = true;
            # };
          }
        # Fixed config
        else
          { ".config/leftwm/config.ron".source = mkIf (cfg.config != null) cfg.config; }
      )
      // {
        ".config/leftwm/themes/current".source = cfg.theme;
        ".config/lefthk/config.ron".source = mkIf cfg.lefthk.enable ./lefthk.ron;
      };
  });
}
