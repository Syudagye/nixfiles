{ config, pkgs, ... }:

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
  };
}
