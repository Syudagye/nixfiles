{ config, pkgs, ... }:

{
  config.home = {
    packages = with pkgs; [
      rofi
    ];

    file.".config/rofi/config.rasi".source = ../home/rofi.config.rasi;
  };
}
