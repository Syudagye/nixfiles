{ config, pkgs, ... }:

let
  alacritty = (pkgs.formats.yaml { }).generate "alacritty.yml" (import ../../config/alacritty.nix { });
in
{
  imports = [
    ../.
    ../desktop-common
    ../../modules/home
  ];

  syu = {
    theming.enable = true;
    shell = {
      enable = true;
      enableStarship = true;
    };
    leftwm = {
      enable = true;
      installPackages = false;
      theme = pkgs.fetchFromGitHub {
        owner = "Syudagye";
        repo = "leftwm-sunset";
        rev = "master";
        sha256 = "0mr3n1nf3z2606clka0cqmzmgsg0n0q8r33dqxnqw0gxs0ri1jmb";
      };
      lefthk.enable = true;
    };
    hyprland = {
      enable = true;
      installWithNix = false;
    };
  };

  home = {
    file.".config/alacritty/alacritty.yml".source = alacritty;
  };

  programs = {
    git.signing = {
      key = "54FC43A3B0AD17F0DBC05DF57C84377B8C861714";
      signByDefault = true;
    };
  };
}
