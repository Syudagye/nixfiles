{ config, pkgs, ... }:

{
  imports = [
    ../../config/common-home.nix
  ];
  home.stateVersion = "22.05";
}
