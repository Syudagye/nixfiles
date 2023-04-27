{ config, pkgs, nix-gaming, leftwm, lefthk, ... }:

{
  config = {
    home = {
      username = "syu";
      homeDirectory = "/home/syu";

      packages = with pkgs; [
        (writeShellScriptBin "nix-trim-generations" (builtins.readFile (fetchurl {
          url = "https://gist.githubusercontent.com/Bondrake/27555c9d02c2882fd5e32f8ab3ed620b/raw/e1e5dd68761a7f7e6a253fcb64905466104b9df9/trim-generations.sh";
          sha256 = "0kkcxazaay71zdf7jqrsh6fpyzyji361fcfzcpdd4dmf68nj8xq3";
        }).outPath))
      ];

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
