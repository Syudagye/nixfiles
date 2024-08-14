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
      (writeShellScriptBin "plasma-fuck-you" (builtins.readFile ./scripts/plasma-fuck-you.sh))

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
    file.".config/alacritty/alacritty.toml".source = ../../config/alacritty.toml;
    file.".config/neovide/config.toml".source = ../../config/neovide.toml;
  };

  services = {
    udiskie = {
      enable = true;
      tray = "never";
    };
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

  gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  fonts.fontconfig.enable = true;
}
