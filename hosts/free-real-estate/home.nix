{ config, pkgs, ... }:

{
  home = {
    username = "syu";
    homeDirectory = "/home/syu";

    packages = with pkgs; [ ];

    stateVersion = "22.05";
  };
}
