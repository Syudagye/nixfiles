{ config, pkgs, ... }:

let
  alacritty = (pkgs.formats.yaml { }).generate "alacritty.yml" (import ../../config/alacritty.nix);
in
{
  imports = [
    ../.
    ../desktop-common
    ../../modules/home
  ];

  targets.genericLinux.enable = true;

  syu = {
    theming.enable = true;
    shell = {
      enable = true;
      enableStarship = true;
      enableOpam = true;
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
    hyprland.enable = true;
  };

  home = {
    file.".config/alacritty/alacritty.yml".source = alacritty;
    file.".config/nix/nix.conf".source = ./nix.conf;
  };

  programs = {
    git.signing = {
      key = "4522BF9BAA21FE93923F311C9DD267B4D9EBFAA1";
      signByDefault = true;
    };
  };
}
