{ config, pkgs, nix-gaming, leftwm, lefthk, ... }:

{
  home = {
    username = "syu";
    homeDirectory = "/home/syu";

    packages = with pkgs; [];

    stateVersion = "22.05";
  };

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "Syudagye";
      userEmail = "syudagye@gmail.com";
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
      defaultKeymap = "emacs"; # This is to avoid zsh to spit out the keybinds on startup
      initExtra = ''
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      '';
    };
  };
}

