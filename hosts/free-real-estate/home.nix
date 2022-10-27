{ config, pkgs, nix-gaming, leftwm, lefthk, ... }:

{
  # nixpkgs.config.allowUnfree = true;
  home = {
    username = "syu";
    homeDirectory = "/home/syu";

    packages = with pkgs; [
      ### Drivers / Utilities
      gnupg
      uwufetch
      neofetch

      ### Dev
      neovim
    ];

    stateVersion = "22.05";
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
  };
}
