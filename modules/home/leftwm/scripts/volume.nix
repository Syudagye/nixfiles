pkgs:
let
  pamixer = "${pkgs.pamixer.outPath}/bin/pamixer";
  dunstify = "${pkgs.dunst.outPath}/bin/dunstify";
in
pkgs.writeShellScriptBin "volume" ''
  changeVolume()
  {
      MAX=100
      vol=$(${pamixer} --get-volume)
      newvol=$((''$vol + $1))

      if [ $1 -lt 0 ]; then
          [ $newvol -le $MAX ] && ${pamixer} -d ''${1:1}
      else
          [ $newvol -le $MAX ] && ${pamixer} -i $1
      fi
  }

  notifyVolume()
  {
      vol=$(${pamixer} --get-volume)
      msg="Volume: $vol%"
      [ "$(${pamixer} --get-mute)" = "true" ] && msg+=" (Muted)"

      ${dunstify} -a "changeVolume" -u low -i audio-volume-high -h int:value:"$vol" -r "69420" "$msg"
  }

  [ "$1" = "mute" ] && ${pamixer} -t || changeVolume "$1"
  notifyVolume
''
