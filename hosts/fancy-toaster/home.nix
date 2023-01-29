{ config, pkgs, lib, nix-gaming, leftwm, lefthk, eww-systray, ... }:

{
  imports = [
    ../../modules/home
    ../../config/rofi.nix
    ../../config/common-home.nix
    ../../config/common-home-desktop.nix
  ];

  syu = {
    theming.enable = true;
    shell = {
      enable = true;
      enableStarship = true;
    };
    leftwm = {
      enable = true;
      lefthk = {
        enable = true;
        laptop = true;
      };
    };
  };

  home.packages = with pkgs; [
    pavucontrol
    lxde.lxsession
    neofetch
    xorg.xkill

    ### Dev
    neovide
    rnix-lsp
    rustup
    nodejs
    mono

    ### custom scripts
    (writeShellScriptBin "tablet-config" (builtins.readFile ../../home/bin/tablet-config))
  ];

  programs = {
    git.signing = {
      key = "0AFDFF91722ADAF50DCE140296D79389A5442C8C";
      signByDefault = true;
    };

    librewolf = {
      enable = true;
      settings = {
        "webgl.disabled" = false;
      };
    };
  };

  xsession = {
    enable = true;
    profileExtra = ''
      lefthk &
      lxsession &
      xrdb ~/.Xresources
    '';
    numlock.enable = true;
  };
}
