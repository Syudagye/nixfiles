{ config, pkgs, lib, nix-gaming, leftwm, lefthk, eww-systray, ... }:

{
  imports = [
    ../../modules/home
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
    lxde.lxsession
    xorg.xkill
    rofi

    ### Dev
    neovide
    rnix-lsp
    rustup
    nodejs
    mono

    river
    ristate
    wayshot
  ];
  home.file.".config/river/init" = {
    executable = true;
    source = (pkgs.writeShellScript "riverctl" (builtins.readFile ../../home/riverctl)).outPath;
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

    alacritty = {
      enable = true;
      settings = import ../../config/alacritty.nix { fontSize = 8; };
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
