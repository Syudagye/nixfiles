{ config, pkgs, lib, nix-gaming, leftwm, lefthk, ... }:

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
    # librewolf = {
    #   enable = true;
    #   settings = {
    #     "webgl.disabled" = false;
    #   };
    # };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      defaultKeymap = "vicmd";
      initExtra = ''
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        clear
      '';
      shellAliases = {
        ls = "exa -l --git --icons";
        la = "ls -a";
      };
    };
    starship = {
      enable = true;
      settings = {
        format = lib.concatStrings [
          "$git_state"
          "$git_branch"
          "$git_status"
          "$package"
          "$rust"
          "$nodejs"
          "\n"
          "$directory(blue)"
          "$character"
        ];
        right_format = lib.concatStrings [ "$status" "$cmd_duration" "$jobs" ];
        character = {
          success_symbol = "[➜](green bold)";
          error_symbol = "[➜](red bold)";
          vicmd_symbol = "[V](green bold)";
        };

        git_branch.format = "[$symbol$branch](green)";
        git_status.format = " ([\\[$all_status$ahead_behind\\]](bold green))";

        package.format = " \\[[$version]($style)\\]";
        rust.format = " \\(rust [$version]($style)\\)";
        nodejs.format = " \\(node [$version]($style)\\)";

        status = {
          format = "[$status]($style)( \\([$common_meaning]($style)\\))";
          disabled = false;
        };
        cmd_duration.format = " \\[took [$duration]($style)\\]";
        jobs .format = " [$symbol$number]($style)";
      };
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
