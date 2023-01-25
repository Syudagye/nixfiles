{ config, pkgs, ... }:

let
  alacritty = (pkgs.formats.yaml { }).generate "alacritty.yml" (import ../../config/alacritty.nix { });
in
{
  # nixpkgs.config.allowUnfree = true;
  home = {
    file.".config/alacritty/alacritty.yml".source = alacritty;
  };
}
