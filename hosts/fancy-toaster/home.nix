{ config, pkgs, nix-gaming, leftwm, lefthk, eww-systray, ... }:

{
  # nixpkgs.config.allowUnfree = true;
  home = {
    packages = with pkgs; [
      ### Drivers / Utilities
      leftwm.packages.${pkgs.system}.leftwm
      lefthk.packages.${pkgs.system}.lefthk
      rofi
      xclip
      maim
      exa
      # eww
      eww-systray.packages.${pkgs.system}.eww
      wmctrl
      xdotool
      feh
      gnupg
      xf86_input_wacom
      pavucontrol
      lxde.lxsession
      neofetch
      xorg.xkill
      brightnessctl

      ### Applications
      krita
      nix-gaming.packages.${pkgs.system}.osu-stable
      nix-gaming.packages.${pkgs.system}.wine-discord-ipc-bridge
      gparted

      ### Dev
      neovim
      neovide
      rnix-lsp
      rustup
      php
      android-studio
      jdk
      dart
      nodejs
      mono

      ### Gaming
      steam
      osu-lazer
      wine-staging

      ### Custom scripts
      (writeShellScriptBin "brightness" (builtins.readFile ../../home/bin/brightness))
      bc # for calculating brightness
    ];

    shellAliases = {
      "ls" = "exa -l --git";
      "la" = "exa -la --git";
    };

    file.".xprofile".source = ../../home/.xprofile;
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
      };
    };

    lf = {
      enable = true;
      settings = {
        drawbox = true;
        icons = true;
        info = "size:time";
        number = true;
        relativenumber = true;
        preview = true;
      };
    };

    alacritty = {
      enable = true;
      settings = import ../../config/alacritty.nix { fontSize = 8; };
      # settings.font.size = 8;
    };
  };

  xsession = {
    profileExtra = ''
      lefthk &
    '';
    numlock.enable = true;
  };

  # xdg.mimeApps = {
  #   enable = true;
  #   associations.added = {
  #     "application/x-ms-dos-executable" = "wine.desktop"; # not working dum
  #     "text/plain" = "neovide.desktop";
  #     "application/x-wine-extension-osk" = "osu-stable.desktop";
  #     "application/x-wine-extension-osz" = "osu-stable.desktop";
  #   };
  #   defaultApplications = {
  #     "inode/directory" = [ "thunar.desktop" ];
  #   };
  # };
}
