{ config, pkgs, lib, nix-gaming, leftwm, lefthk, ... }:

{
  imports = [
    ../../config/dunst.nix
    ../../config/rofi
  ];
  # config = {
  home = {
    packages = with pkgs; [
      ### Custom scripts
      (writeShellScriptBin "tablet-config" (builtins.readFile ./scripts/tablet-config))
    ];
    sessionVariables = {
      EDITOR = "nvim";
      XKB_DEFAULT_LAYOUT = "fr";
    };
  };

  services = {
    udiskie.enable = true;
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
      # };
    };
  };
}