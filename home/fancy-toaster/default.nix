{ config, pkgs, lib, nix-gaming, leftwm, lefthk, eww, ... }:

{
  imports = [
    ../.
    ../desktop-common

    ../../modules/home

    ../../config/river
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
    hyprland.enable = true;
  };

  home = {
    packages = with pkgs; [
      rofi
      (eww.packages.x86_64-linux.eww)

      ### Dev
      neovide
      rustup
      nodejs
      mono

      river
      ristate
      wayshot
    ];
  };

  programs = {
    git.signing = {
      key = "0AFDFF91722ADAF50DCE140296D79389A5442C8C";
      signByDefault = true;
    };

    librewolf = {
      enable = true;
      settings = {
        "webgl.disabled" = false;
        "middlemouse.paste" = false;
      };
    };

    alacritty.enable = true;
  };

  xsession = {
    enable = true;
    profileExtra = ''
      ${lefthk.packages.x86_64-linux.lefthk.outPath}/bin/lefthk &
      ${pkgs.lxde.lxsession.outPath}/bin/lxpolkit &
      xrdb ~/.Xresources
    '';
    numlock.enable = true;
  };

  xresources.properties = {
    "Xft.dpi" = 96; # Fix for font size in alacritty + neovide
  };
}
