pkgs:
let
  gencfg = (
    fileName: keybinds:
    pkgs.writeText fileName ''
      //  _        ___                                      ___ _
      // | |      / __)_                                   / __|_)
      // | | ____| |__| |_ _ _ _ ____      ____ ___  ____ | |__ _  ____    ____ ___  ____
      // | |/ _  )  __)  _) | | |    \    / ___) _ \|  _ \|  __) |/ _  |  / ___) _ \|  _ \
      // | ( (/ /| |  | |_| | | | | | |  ( (__| |_| | | | | |  | ( ( | |_| |  | |_| | | | |
      // |_|\____)_|   \___)____|_|_|_|   \____)___/|_| |_|_|  |_|\_|| (_)_|   \___/|_| |_|
      // A WindowManager for Adventurers                         (____/
      // For info about configuration please visit https://github.com/leftwm/leftwm/wiki

      #![enable(implicit_some)]
      (
          log_level: "debug",
          backend: X11rb,
          // backend: XLib,
          modkey: "Mod4",
          mousekey: "Mod4",
          workspaces: [
              (output: "HDMI-1", y: 0, x:0, width: 1920, height: 1080),
              (output: "DP-1", y: 0, x:1920, width: 1920, height: 1080),
          ],
          tags: [
              "dev",
              "web",
              "game",
              "draw",
              "5",
              "6",
              "vid",
              "vm",
              "dl",
              "social",
          ],
          max_window_width: None,
          layouts: [
              "MainAndVertStack",
              "MainAndHorizontalStack",
              "MainAndDeck",
              "Fibonacci",
              "Monocle",
          ],
          layout_mode: Tag,
          insert_behavior: Bottom,
          scratchpad: [
              (name: "Alacritty", value: "alacritty", x: None, y: None, height: None, width: None),
              (name: "htop", value: "alacritty -e htop", x: 100, y: 100, height: 600, width: 1000),
          ],
          window_rules: [
              (window_class: "Steam", window_title: None, spawn_on_tag: 5, spawn_floating: None),
          ],
          disable_current_tag_swap: true,
          disable_tile_drag: false,
          disable_window_snap: true,
          focus_behaviour: Sloppy,
          focus_new_windows: true,
          sloppy_mouse_follows_focus: false,
          keybind: [
              ${keybinds}
          ],
          state_path: None,
      )
    ''
  );
  switchToVariant = (
    pkgs.writeShellScript "leftwm-switch-to-variant" ''
      setxkbmap fr "$1"
      configPath="$XDG_CONFIG_HOME/leftwm/config.ron"

      rm "$configPath"
      if [ "$1" = "ergol" ]; then
        ln -s $XDG_CONFIG_HOME/leftwm/ergol.ron "$configPath"
      else
        ln -s $XDG_CONFIG_HOME/leftwm/azerty.ron "$configPath"
      fi

      leftwm-command SoftReload
    ''
  );
  azertyKeybinds = ''
    (command: Execute, value: "rofi -show drun", modifier: ["modkey"], key: "d"),
    (command: Execute, value: "alacritty", modifier: ["modkey"], key: "Return"),
    (command: ToggleScratchPad, value: "Alacritty", modifier: ["modkey"], key: "s"),
    (command: ToggleScratchPad, value: "htop", modifier: ["modkey"], key: "F1"),
    (command: CloseWindow, value: "", modifier: ["modkey", "Shift"], key: "q"),
    (command: SoftReload, value: "", modifier: ["modkey", "Shift"], key: "r"),
    (command: Execute, value: "loginctl kill-session $XDG_SESSION_ID", modifier: ["modkey", "Shift"], key: "x"),
    (command: SwapTags, value: "", modifier: ["modkey"], key: "w"),
    (command: MoveWindowUp, value: "", modifier: ["modkey", "Shift"], key: "Up"),
    (command: MoveWindowUp, value: "", modifier: ["modkey", "Shift"], key: "k"),
    (command: MoveWindowDown, value: "", modifier: ["modkey", "Shift"], key: "Down"),
    (command: MoveWindowDown, value: "", modifier: ["modkey", "Shift"], key: "j"),
    (command: MoveWindowTop, value: "", modifier: ["modkey", "Shift"], key: "Return"),
    (command: ToggleFullScreen, value: "", modifier: ["modkey"], key: "f"),
    (command: ToggleFloating, value: "", modifier: ["modkey", "Shift"], key: "space"),
    (command: FocusWindowUp, value: "", modifier: ["modkey"], key: "Up"),
    (command: FocusWindowUp, value: "", modifier: ["modkey"], key: "k"),
    (command: FocusWindowDown, value: "", modifier: ["modkey"], key: "Down"),
    (command: FocusWindowDown, value: "", modifier: ["modkey"], key: "j"),
    (command: IncreaseMainWidth, value: "5", modifier: ["modkey", "Control"], key: "Up"),
    (command: IncreaseMainWidth, value: "5", modifier: ["modkey"], key: "l"),
    (command: DecreaseMainWidth, value: "5", modifier: ["modkey", "Control"], key: "Down"),
    (command: DecreaseMainWidth, value: "5", modifier: ["modkey"], key: "h"),
    (command: NextLayout, value: "", modifier: ["modkey"], key: "equal"),
    (command: PreviousLayout, value: "", modifier: ["modkey"], key: "parenright"),
    (command: GotoTag, value: "1", modifier: ["modkey"], key: "ampersand"),
    (command: GotoTag, value: "2", modifier: ["modkey"], key: "eacute"),
    (command: GotoTag, value: "3", modifier: ["modkey"], key: "quotedbl"),
    (command: GotoTag, value: "4", modifier: ["modkey"], key: "apostrophe"),
    (command: GotoTag, value: "5", modifier: ["modkey"], key: "parenleft"),
    (command: GotoTag, value: "6", modifier: ["modkey"], key: "minus"),
    (command: GotoTag, value: "7", modifier: ["modkey"], key: "egrave"),
    (command: GotoTag, value: "8", modifier: ["modkey"], key: "underscore"),
    (command: GotoTag, value: "9", modifier: ["modkey"], key: "ccedilla"),
    (command: GotoTag, value: "10", modifier: ["modkey"], key: "dollar"),
    (command: MoveToTag, value: "1", modifier: ["modkey", "Shift"], key: "ampersand"),
    (command: MoveToTag, value: "2", modifier: ["modkey", "Shift"], key: "eacute"),
    (command: MoveToTag, value: "3", modifier: ["modkey", "Shift"], key: "quotedbl"),
    (command: MoveToTag, value: "4", modifier: ["modkey", "Shift"], key: "apostrophe"),
    (command: MoveToTag, value: "5", modifier: ["modkey", "Shift"], key: "parenleft"),
    (command: MoveToTag, value: "6", modifier: ["modkey", "Shift"], key: "minus"),
    (command: MoveToTag, value: "7", modifier: ["modkey", "Shift"], key: "egrave"),
    (command: MoveToTag, value: "8", modifier: ["modkey", "Shift"], key: "underscore"),
    (command: MoveToTag, value: "9", modifier: ["modkey", "Shift"], key: "ccedilla"),
    (command: MoveToTag, value: "10", modifier: ["modkey", "Shift"], key: "dollar"),
    (command: ToggleSticky, value: "", modifier: ["modkey"], key: "p"),
    (command: Execute, value: "${switchToVariant} ergol", modifier: ["modkey"], key: "F4"),
  '';
  ergolKeybinds = ''
    (command: Execute, value: "rofi -show drun", modifier: ["modkey"], key: "e"),
    (command: Execute, value: "alacritty", modifier: ["modkey"], key: "Return"),
    (command: CloseWindow, value: "", modifier: ["modkey", "Shift"], key: "q"),
    (command: SoftReload, value: "", modifier: ["modkey", "Shift"], key: "r"),
    (command: Execute, value: "loginctl kill-session $XDG_SESSION_ID", modifier: ["modkey", "Shift"], key: "x"),
    (command: MoveWindowUp, value: "", modifier: ["modkey", "Shift"], key: "Up"),
    (command: MoveWindowUp, value: "", modifier: ["modkey", "Shift"], key: "t"),
    (command: MoveWindowDown, value: "", modifier: ["modkey", "Shift"], key: "Down"),
    (command: MoveWindowDown, value: "", modifier: ["modkey", "Shift"], key: "r"),
    (command: MoveWindowTop, value: "", modifier: ["modkey", "Shift"], key: "Return"),
    (command: ToggleFullScreen, value: "", modifier: ["modkey"], key: "f"),
    (command: ToggleFloating, value: "", modifier: ["modkey", "Shift"], key: "space"),
    (command: FocusWindowUp, value: "", modifier: ["modkey"], key: "Up"),
    (command: FocusWindowUp, value: "", modifier: ["modkey"], key: "t"),
    (command: FocusWindowDown, value: "", modifier: ["modkey"], key: "Down"),
    (command: FocusWindowDown, value: "", modifier: ["modkey"], key: "r"),
    (command: IncreaseMainWidth, value: "5", modifier: ["modkey", "Control"], key: "Up"),
    (command: IncreaseMainWidth, value: "5", modifier: ["modkey"], key: "i"),
    (command: DecreaseMainWidth, value: "5", modifier: ["modkey", "Control"], key: "Down"),
    (command: DecreaseMainWidth, value: "5", modifier: ["modkey"], key: "l"),
    (command: PreviousLayout, value: "", modifier: ["modkey"], key: "slash"),
    (command: NextLayout, value: "", modifier: ["modkey"], key: "equal"),
    (command: GotoTag, value: "1", modifier: ["modkey"], key: "1"),
    (command: GotoTag, value: "2", modifier: ["modkey"], key: "2"),
    (command: GotoTag, value: "3", modifier: ["modkey"], key: "3"),
    (command: GotoTag, value: "4", modifier: ["modkey"], key: "4"),
    (command: GotoTag, value: "5", modifier: ["modkey"], key: "5"),
    (command: GotoTag, value: "6", modifier: ["modkey"], key: "6"),
    (command: GotoTag, value: "7", modifier: ["modkey"], key: "7"),
    (command: GotoTag, value: "8", modifier: ["modkey"], key: "8"),
    (command: GotoTag, value: "9", modifier: ["modkey"], key: "9"),
    (command: GotoTag, value: "10", modifier: ["modkey"], key: "bracketright"),
    (command: MoveToTag, value: "1", modifier: ["modkey", "Shift"], key: "1"),
    (command: MoveToTag, value: "2", modifier: ["modkey", "Shift"], key: "2"),
    (command: MoveToTag, value: "3", modifier: ["modkey", "Shift"], key: "3"),
    (command: MoveToTag, value: "4", modifier: ["modkey", "Shift"], key: "4"),
    (command: MoveToTag, value: "5", modifier: ["modkey", "Shift"], key: "5"),
    (command: MoveToTag, value: "6", modifier: ["modkey", "Shift"], key: "6"),
    (command: MoveToTag, value: "7", modifier: ["modkey", "Shift"], key: "7"),
    (command: MoveToTag, value: "8", modifier: ["modkey", "Shift"], key: "8"),
    (command: MoveToTag, value: "9", modifier: ["modkey", "Shift"], key: "9"),
    (command: MoveToTag, value: "10", modifier: ["modkey", "Shift"], key: "bracketright"),
    (command: ToggleSticky, value: "", modifier: ["modkey"], key: "p"),
    (command: Execute, value: "${switchToVariant}", modifier: ["modkey"], key: "F4"),
  '';
in
{
  azerty = gencfg "azerty.ron" azertyKeybinds;
  ergol = gencfg "ergol.ron" ergolKeybinds;
}
