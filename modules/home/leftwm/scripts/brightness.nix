pkgs:
let
  bctl = "${pkgs.brightnessctl.outPath}/bin/brightnessctl";
in
pkgs.writeShellScriptBin "brightness" ''
  MAX=$(${bctl} m)
  CURR=$(${bctl} g)

  if [ $CURR -gt $MAX ]; then
      ${bctl} s $MAX
  else
      brightness=$(($CURR + $1))
      ${bctl} s $brightness
  fi

  b=$(bc -l <<< "scale = 0; $(bc -l <<< "scale = 2; $CURR / $MAX") * 100")
  b=''${b:0:-3}
  msg="Brightness: $b%"
  dunstify -a "changeBrightness" -u low -h int:value:"$b" -r "69420" "$msg"
''
