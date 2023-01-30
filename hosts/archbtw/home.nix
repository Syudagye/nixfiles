{ config, pkgs, ... }:

let
  alacritty = (pkgs.formats.yaml { }).generate "alacritty.yml" (import ../../config/alacritty.nix { });
in
{
  imports = [
    ../../modules/home
    ../../config/rofi.nix
    ../../config/common-home.nix
    ../../config/common-home-desktop.nix
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
        sha256 = "1gvvyjlmkbwf11z99glbhh2svr2537sbwhym5292b37718c97mkl";
      };
      lefthk.enable = true;
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
