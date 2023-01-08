{ config, pkgs, nix-gaming, leftwm, lefthk, home-manager, ... }:

{
  # nixpkgs.config.allowUnfree = true;
  home = {
    username = "syu";
    homeDirectory = "/home/syu";

    packages = with pkgs; [
      home-manager.packages.${pkgs.system}.home-manager

      ### Custom scripts
      (writeShellScriptBin "tablet-config" (builtins.readFile ../../home/bin/tablet-config))
      (writeShellScriptBin "volume" (builtins.readFile ../../home/bin/volume))
    ];

    stateVersion = "22.05";

  };
  xresources.properties = { "Xcursor.theme" = "Breeze"; };
}
