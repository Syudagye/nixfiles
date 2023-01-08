{ config, pkgs, nix-gaming, leftwm, lefthk, home-manager, breezex-cursor, ... }:

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
    pointerCursor = {
      x11.enable = true;
      package = breezex-cursor;
      name = "BreezeX-Dark";
      size = 28;
    };

    stateVersion = "22.05";
  };
}
