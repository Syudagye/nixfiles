{ config, pkgs, lib, nix-gaming, leftwm, lefthk, ... }:

{
  imports = [
    ../../config/dunst.nix
    ../../config/rofi
  ];

  home = {
    packages = with pkgs; let
      tex = (texlive.combine {
        inherit (texlive) scheme-full xcolor booktabs fancyvrb;
      });
    in
    [
      ### Custom scripts
      (writeShellScriptBin "tablet-config" (builtins.readFile ./scripts/tablet-config))

      ### Common packages
      tex
      pandoc

      iosevka-bin
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
    ];
    sessionVariables = {
      EDITOR = "nvim";
      XKB_DEFAULT_LAYOUT = "fr";
    };

    file.".config/fontconfig/fonts.conf".source = ./fonts.conf;
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
    };
  };

  fonts.fontconfig.enable = true;
}
