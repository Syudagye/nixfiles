# ZSH, Starship and shell related things
{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.syu.shell;
in
{
  options.syu.shell = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    enableStarship = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      eza
      opam
    ];
    programs = {
      zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        defaultKeymap = "emacs"; # This is to avoid zsh to spit out the keybinds on startup
        initExtra = ''
          source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        '';
        shellAliases = {
          la = "ls -a";
        };
      };
      starship = {
        enable = cfg.enableStarship;
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
  };
}
