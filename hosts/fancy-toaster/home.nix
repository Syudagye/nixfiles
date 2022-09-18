{ config, pkgs, nix-gaming, leftwm, ... }:

{
  # nixpkgs.config.allowUnfree = true;
  home = {
    username = "syu";
    homeDirectory = "/home/syu";

    packages = with pkgs; [
      ### Drivers / Utilities
      leftwm.packages.${pkgs.system}.leftwm
      rofi
      xclip
      maim
      exa
      eww
      wmctrl
      pavucontrol
      lxde.lxsession
      xdotool
      dunst
      feh
      gnupg
      uwufetch
      neofetch
      xf86_input_wacom
      xorg.xkill

      ### Applications
      krita
      librewolf
      nix-gaming.packages.${pkgs.system}.osu-stable
      nix-gaming.packages.${pkgs.system}.wine-discord-ipc-bridge
      gparted

      ### Dev
      neovim
      neovide
      rnix-lsp
      rustup

      ### Gaming
      steam
      osu-lazer
      wine-staging
      # nix-gaming.packages.x86_64-linux.osu-stable.override rec {
      #   wine = pkgs.wineWowPackages.staging;
      #   wine-discord-ipc-bridge = nix-gaming.wine-discord-ipc-bridge.override { inherit wine; };
      # }

      ### Custom scripts
      (writeShellScriptBin "tablet-config" (builtins.readFile ../../home/bin/tablet-config))
    ];

    shellAliases = {
      "ls" = "exa -l --git";
      "la" = "exa -la --git";
    };

    stateVersion = "22.05";

    file.".config/leftwm/config.ron".source = ../../home/leftwm/config.ron;
    file.".config/leftwm/themes/current".source = ../../home/leftwm/themes/fancy-toaster;
    file.".config/rofi/config.rasi".source = ../../home/rofi.config.rasi;
  };

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "Syudagye";
      userEmail = "syudagye@gmail.com";
      signing = {
        key = "0AFDFF91722ADAF50DCE140296D79389A5442C8C";
        signByDefault = true;
      };
    };

    alacritty = {
      enable = true;
      settings = {
        window = {
          padding = {
            x = 10;
            y = 9;
          };
          dynamic_padding = true;
          dynamic_title = true;
        };
        font = {
          normal = {
            family = "Iosevka Term";
            style = "Regular";
          };
          bold = {
            family = "Iosevka Term";
            style = "Regular";
          };
          italic = {
            family = "Iosevka Term";
            style = "Regular";
          };
          bold_italic = {
            family = "Iosevka Term";
            style = "Bold Italic";
          };
          size = 8;
          offset.x = 1;
        };
        colors = {
          background = "#2e2e38";
          foreground = "#c7c7d1";
        };
      };

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

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      defaultKeymap = "vicmd";
    };
  };

  services = {
    udiskie.enable = true;
  };

  gtk = {
    enable = true;
    # cursorTheme.package = pkgs.libsForQt5.breeze-gtk;
    theme = {
      name = "Matcha-dark-sea";
      package = pkgs.matcha-gtk-theme;
    };
    cursorTheme = {
      name = "Breeze";
      package = pkgs.libsForQt5.breeze-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  # xsession = {
  #   enable = true;
  #   numlock.enable = true;
  #   windowManager.command = "${leftwm.packages.${pkgs.system}.leftwm}/bin/leftwm";
  # };

  xdg = {
    enable = true;
    # mimeApps = {
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
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "$HOME";
      documents = "$HOME/documents";
      download = "$HOME/downloads";
      music = "$HOME/music";
      pictures = "$HOME/images";
      publicShare = "$HOME";
      templates = "$HOME";
      videos = "$HOME/videos";
    };
  };
}
