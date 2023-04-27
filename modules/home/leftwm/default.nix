# LeftWM and LeftHK
{ lib, pkgs, config, eww-systray, leftwm, lefthk, ... } @ inputs:

with lib;
let
  cfg = config.syu.leftwm;
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

  config.home = mkIf cfg.enable {
    packages = with pkgs; [
      (mkIf cfg.installPackages leftwm.packages.${pkgs.system}.leftwm)
    ]

    # import the theme
    ++ (import (cfg.theme + /deps.nix)) inputs

    # setup lefthk
    ++ (if cfg.lefthk.enable then [
      (mkIf cfg.installPackages lefthk.packages.${pkgs.system}.lefthk)

      xclip
      maim
      (writeShellScriptBin "volume" (builtins.readFile ./scripts/volume))
    ]
    # laptop specific config
    ++ (if cfg.lefthk.laptop then [
      (writeShellScriptBin "brightness" (builtins.readFile ./scripts/brightness))
      bc
      brightnessctl
    ] else [ ])
    else [ ]);

    file.".config/leftwm/config.ron".source = ./config.ron;
    file.".config/leftwm/themes/current".source = cfg.theme;

    file.".config/lefthk/config.ron".source = mkIf cfg.lefthk.enable ./lefthk.ron;
  };
}
