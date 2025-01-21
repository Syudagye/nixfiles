{ pkgs, ... }:

with pkgs;
[
  picom
  feh
  xdotool
  # eww
  # eww-systray.packages.${pkgs.system}.eww
]
