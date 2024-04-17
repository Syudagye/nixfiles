{ config, pkgs, nix-gaming, leftwm, lefthk, hyprland, ... }:

{
  imports = [
    hyprland.homeManagerModules.default
  ];

  config = {
    home = {
      username = "syu";
      homeDirectory = "/home/syu";

      packages = with pkgs; [
        (writeShellScriptBin "nix-trim-generations" (builtins.readFile (fetchurl {
          url = "https://gist.githubusercontent.com/MaxwellDupre/3077cd229490cf93ecab08ef2a79c852/raw/ccb39ba6304ee836738d4ea62999f4451fbc27f7/trim-generations.sh";
          sha256 = "17qi417436d57f7kbnwm70dakqg377rf6ss1r11xp92jq61r71ch";
        }).outPath))
        sccache
        emscripten
      ];

      sessionPath = [
        "$HOME/.cargo/bin"
        "$HOME/.local/bin"
      ];

      sessionVariables = {
        RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
        C_INCLUDE_PATH = "${pkgs.emscripten}/share/emscripten/cache/sysroot/include/";
      };

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

      eza.enable = true;
    };
  };
}
