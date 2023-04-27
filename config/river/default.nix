{ pkgs, ... }:
{
  home.file.".config/river/init" = {
    executable = true;
    source = (pkgs.writeShellScript "riverctl" (builtins.readFile ./riverctl)).outPath;
  };
}
