{ config, pkgs, nix-gaming, leftwm, lefthk, ... }:

{
  config = {
    home = {
      username = "syu";
      homeDirectory = "/home/syu";

      packages = with pkgs; [ ];

      sessionPath = [
        "$HOME/.cargo/bin"
        "$HOME/.local/bin"
      ];

      stateVersion = "22.05";
    };

    programs = {
      home-manager.enable = true;

      git = {
        enable = true;
        userName = "Syudagye";
        userEmail = "syudagye@gmail.com";
      };

      lf = {
        enable = true;
        settings = {
          drawbox = true;
          icons = true;
          info = "size:time";
          number = true;
          relativenumber = true;
          preview = true;
        };
      };
    };
  };
}
