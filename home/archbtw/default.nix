{ config, pkgs, ... }:

{
  imports = [
    ../.
    ../desktop-common
    ../../modules/home
  ];

  nix.package = pkgs.nixVersions.nix_2_23;

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
      config = ./leftwm.ron;
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
    file.".config/alacritty/alacritty.toml".source = ../../config/alacritty.toml;
  };

  programs = {
    git.signing = {
      key = "78018CDAA4B29AB20174988A1FC9186530C9A9DD";
      signByDefault = true;
    };
  };
}
