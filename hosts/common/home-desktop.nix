{ config, pkgs, nix-gaming, leftwm, lefthk, ... }:

{
  home = {
    packages = with pkgs; [
      ### Custom scripts
      (writeShellScriptBin "tablet-config" (builtins.readFile ../../home/bin/tablet-config))
      (writeShellScriptBin "volume" (builtins.readFile ../../home/bin/volume))
    ];

    file.".config/leftwm/config.ron".source = ../../home/leftwm/config.ron;
    file.".config/leftwm/themes/fancy-toaster".source = ../../home/leftwm/themes/fancy-toaster;
    file.".config/rofi/config.rasi".source = ../../home/rofi.config.rasi;
    file.".config/lefthk/config.ron".source = ../../home/lefthk.ron;
  };

  programs = {
    # TODO: Improve browser related config
    librewolf = {
      enable = true;
      settings = {
        "webgl.disabled" = false;
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
}
