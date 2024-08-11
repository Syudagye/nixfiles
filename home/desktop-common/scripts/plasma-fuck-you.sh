# File names take from https://github.com/shalva97/kde-configuration-files/blob/741133ac56eb53e7c8f4e856d0ad45a29e365431/scripts/delete-kde-configuration-files.fish
files=(
  # Plasma specific config files
  "Trolltech.conf" "akregatorrc" "baloofilerc" "bluedevilglobalrc" "kactivitymanagerd-statsrc"
  "kactivitymanagerdrc" "kactivitymanagerd-pluginsrc" "kateschemarc" "kcmfonts" "kcminputrc" "kconf_updaterc" "kded5rc"
  "kdeglobals" "kfontinstuirc" "kglobalshortcutsrc" "khotkeysrc" "kmixctrlrc" "kmixrc"
  "kscreenlockerrc" "ksmserverrc" "ksplashrc" "ktimezonedrc" "kwinrc" "kwinrulesrc" "plasma-localerc"
  "plasma-nm" "plasma-org.kde.plasma.desktop-appletsrc" "plasmarc" "plasmashellrc"
  "powermanagementprofilesrc" "startupconfig" "startupconfigfiles" "startupconfigkeys"
  "krunnerrc" "touchpadxlibinputrc" "systemsettingsrc" "kxkbrc" "PlasmaUserFeedback"
  "kde.org/*" "kiorc" "klipperrc" "knfsshare" "kuriikwsfilterrc" "kwalletmanager5rc" "kwalletrc"
  "plasma.emojierrc" "plasmanotifyrc" "PlasmaUserFeedback" "powerdevilrc" "kgammarc3"
  "kded_device_automounterrc" "device_automounter_kcmrc" "klaunchrc"
  "trashrc" "kactivitymanagerd-switcher" "gtkrc-2.0" "gtkrc" "baloofileinformationrc"
  "breezerc"

  # gtk files
  "gtkrc" "gtkrc-2.0" "gtk-3.0/colors.css" "gtk-3.0/gtk.css" "gtk-4.0/colors.css"
)

for f in ${files[@]}
do
  file="$XDG_CONFIG_HOME"/"$f"
  echo "removing ${file}..."
  rm "$file"
done
