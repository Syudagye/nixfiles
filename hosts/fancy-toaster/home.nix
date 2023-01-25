{ config, pkgs, lib, nix-gaming, leftwm, lefthk, eww-systray, ... } @ inputs:

{
  imports = [
    ../../modules/home
  ];

  syu = {
    theming.enable = true;
    shell = {
      enable = true;
      enableStarship = true;
    };
  };

  # nixpkgs.config.allowUnfree = true;
  home = {
    username = "syu";
    homeDirectory = "/home/syu";


    stateVersion = "22.05";
    packages = with pkgs; [
      ### Drivers / Utilities
      leftwm.packages.${pkgs.system}.leftwm
      lefthk.packages.${pkgs.system}.lefthk
      rofi
      xclip
      maim
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
      # nix-gaming.packages.${pkgs.system}.osu-stable
      # nix-gaming.packages.${pkgs.system}.wine-discord-ipc-bridge
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

      (writeShellScriptBin "tablet-config" (builtins.readFile ../../home/bin/tablet-config))
      (writeShellScriptBin "volume" (builtins.readFile ../../home/bin/volume))
    ];

    # file.".xprofile".source = ../../home/.xprofile;
    file.".config/leftwm/config.ron".source = ../../home/leftwm/config.ron;
    file.".config/leftwm/themes/current".source = ../../home/leftwm/themes/fancy-toaster;
    file.".config/rofi/config.rasi".source = ../../home/rofi.config.rasi;
    file.".config/lefthk/config.ron".source = ../../home/lefthk.ron;
  };

  services = {
    udiskie.enable = true;

    dunst = {
      enable = true;
      settings = {
        global = {
          offset = "6x40";
          frame_width = 2;
          separator_color = "frame";
          highlight = "#ffa666";
          progress_bar_frame_width = 0;
        };
        urgency_low = {
          background = "#2e2e38";
          frame_color = "#c7c7d1";
          foreground = "#c7c7d1";
        };
        urgency_normal = {
          background = "#2e2e38";
          frame_color = "#ffa666";
          foreground = "#c7c7d1";
        };
        urgency_critical = {
          background = "#ffa666";
          frame_color = "#ffa666";
          foreground = "#2e2e38";
        };
      };
    };
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "$HOME/Desktop";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Images";
      publicShare = "$HOME";
      templates = "$HOME";
      videos = "$HOME/Videos";
    };
  };
  programs = {
    home-manager.enable = true;
  };
  programs = {
    git = {
      enable = true;
      userName = "Syudagye";
      userEmail = "syudagye@gmail.com";
    };
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
    enable = true;
    profileExtra = ''
      lefthk &
      lxsession &
      xrdb ~/.Xresources
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
