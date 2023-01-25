{ config, pkgs, ... }:

let
  alacritty = (pkgs.formats.yaml { }).generate "alacritty.yml" (import ../../config/alacritty.nix { });
in
{
  imports = [
    ../../modules/home
  ];

  syu = {
    theming.enable = true;
    shell = {
      enable = true;
      enableStarship = true;
    };
  };

  home = {
    file.".config/alacritty/alacritty.yml".source = alacritty;
  };
}
