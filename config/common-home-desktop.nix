{ config, pkgs, lib, nix-gaming, leftwm, lefthk, ... }:

{
  imports = [
    ../config/rofi.nix
  ];

  config = {
    home = {
      packages = with pkgs; [
        ### Custom scripts
        (writeShellScriptBin "tablet-config" (builtins.readFile ../home/bin/tablet-config))
      ];
      sessionVariables = {
        EDITOR = "nvim";
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
  };
}
