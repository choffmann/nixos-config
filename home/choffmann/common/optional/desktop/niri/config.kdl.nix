{
  lib,
  terminal,
  extraConfig,
  extraBinds,
  extraInput,
  borderActiveColor,
  borderInactiveColor,
  polkitAgent,
}:
let
  # Workspaces are dynamic and per-output, so these are INDEXES, not names.
  workspaceBinds = lib.concatMapStringsSep "\n" (n: ''
    Mod+${toString n} { focus-workspace ${toString n}; }
    Mod+Ctrl+${toString n} { move-column-to-workspace ${toString n}; }'') (lib.range 1 9);
in
''
  input {
      keyboard {
          xkb {
              layout "us"
              variant "altgr-intl"
              options "caps:escape"
          }
      }

      touchpad {
          tap
          natural-scroll
      }

      // Keeps niri's upstream Mod+... bindings while Mod stays under the thumb.
      mod-key "Alt"

      // 0% restricts this to fully visible windows, so hovering never scrolls
      // the view to pull a half-visible column into focus.
      focus-follows-mouse max-scroll-amount="0%"

  ${extraInput}
  }

  layout {
      // niri paints an opaque solid colour behind windows by default, so
      // translucent clients blend against that instead of the wallpaper.
      background-color "transparent"

      gaps 0
      center-focused-column "never"

      preset-column-widths {
          proportion 0.33333
          proportion 0.5
          proportion 0.66667
      }

      default-column-width { proportion 0.5; }

      focus-ring {
          off
      }

      border {
          width 1
          active-color "${borderActiveColor}"
          inactive-color "${borderInactiveColor}"
      }
  }

  prefer-no-csd
  screenshot-path "~/Pictures/Screenshots/screenshot-%Y-%m-%d-%H%M%S.png"

  hotkey-overlay {
      skip-at-startup
  }

  environment {
      DISPLAY ":0"
  }

  spawn-at-startup "xwayland-satellite" ":0"
  spawn-at-startup "${polkitAgent}"

  binds {
      Mod+Shift+Slash { show-hotkey-overlay; }

      Mod+Return hotkey-overlay-title="Open a Terminal" { spawn "${terminal}"; }
      Mod+T      hotkey-overlay-title="Open a Terminal" { spawn "${terminal}"; }
      Mod+E      hotkey-overlay-title="Open a File Manager" { spawn "${terminal}" "-e" "yazi"; }
      Mod+D      hotkey-overlay-title="Run an Application" { spawn "dms" "ipc" "call" "spotlight" "toggle"; }
      Mod+Space  hotkey-overlay-title="Run an Application" { spawn "dms" "ipc" "call" "spotlight" "toggle"; }
      Super+Alt+L hotkey-overlay-title="Lock the Screen" { spawn "dms" "ipc" "call" "lock" "lock"; }

      Mod+P       { spawn "dms" "ipc" "call" "clipboard" "toggle"; }
      Mod+X       { spawn "dms" "ipc" "call" "powermenu" "toggle"; }
      Mod+N       { spawn "dms" "ipc" "call" "notifications" "toggle"; }
      Mod+Shift+N { spawn "dms" "ipc" "call" "notifications" "toggleDoNotDisturb"; }

      // rofi covers what DMS has no equivalent for.
      Mod+B             { spawn "rofi-rbw"; }
      Mod+Shift+B       { spawn "ktt-rofi"; }
      Mod+S             { spawn "rofi" "-show" "ssh"; }
      Mod+Shift+C       { spawn "rofi" "-show" "calc" "-no-show-match" "-no-sort"; }
      Mod+Shift+Period  { spawn "rofi" "-show" "emoji"; }
      Mod+A             { spawn "sh" "-c" "grim -g \"$(slurp)\" - | satty -f -"; }

      XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "5%+"; }
      XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
      XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      XF86AudioMicMute     allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }
      XF86AudioPlay        allow-when-locked=true { spawn "playerctl" "play-pause"; }
      XF86AudioStop        allow-when-locked=true { spawn "playerctl" "stop"; }
      XF86AudioPrev        allow-when-locked=true { spawn "playerctl" "previous"; }
      XF86AudioNext        allow-when-locked=true { spawn "playerctl" "next"; }
      XF86MonBrightnessUp   allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
      XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }

      Mod+O repeat=false { toggle-overview; }
      Mod+Q repeat=false { close-window; }

      Mod+Left  { focus-column-left; }
      Mod+Down  { focus-window-down; }
      Mod+Up    { focus-window-up; }
      Mod+Right { focus-column-right; }
      Mod+H     { focus-column-left; }
      Mod+J     { focus-window-down; }
      Mod+K     { focus-window-up; }
      Mod+L     { focus-column-right; }

      Mod+Ctrl+Left  { move-column-left; }
      Mod+Ctrl+Down  { move-window-down; }
      Mod+Ctrl+Up    { move-window-up; }
      Mod+Ctrl+Right { move-column-right; }
      Mod+Ctrl+H     { move-column-left; }
      Mod+Ctrl+J     { move-window-down; }
      Mod+Ctrl+K     { move-window-up; }
      Mod+Ctrl+L     { move-column-right; }

      Mod+Home { focus-column-first; }
      Mod+End  { focus-column-last; }
      Mod+Ctrl+Home { move-column-to-first; }
      Mod+Ctrl+End  { move-column-to-last; }

      Mod+Shift+Left  { focus-monitor-left; }
      Mod+Shift+Down  { focus-monitor-down; }
      Mod+Shift+Up    { focus-monitor-up; }
      Mod+Shift+Right { focus-monitor-right; }
      Mod+Shift+H     { focus-monitor-left; }
      Mod+Shift+J     { focus-monitor-down; }
      Mod+Shift+K     { focus-monitor-up; }
      Mod+Shift+L     { focus-monitor-right; }

      Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
      Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
      Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
      Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
      Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
      Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

      Mod+Page_Down      { focus-workspace-down; }
      Mod+Page_Up        { focus-workspace-up; }
      Mod+U              { focus-workspace-down; }
      Mod+I              { focus-workspace-up; }
      Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
      Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
      Mod+Ctrl+U         { move-column-to-workspace-down; }
      Mod+Ctrl+I         { move-column-to-workspace-up; }
      Mod+Shift+Page_Down { move-workspace-down; }
      Mod+Shift+Page_Up   { move-workspace-up; }
      Mod+Shift+U         { move-workspace-down; }
      Mod+Shift+I         { move-workspace-up; }

      Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
      Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
      Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
      Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }
      Mod+WheelScrollRight      { focus-column-right; }
      Mod+WheelScrollLeft       { focus-column-left; }
      Mod+Ctrl+WheelScrollRight { move-column-right; }
      Mod+Ctrl+WheelScrollLeft  { move-column-left; }

      Mod+BracketLeft  { consume-or-expel-window-left; }
      Mod+BracketRight { consume-or-expel-window-right; }
      Mod+Comma  { consume-window-into-column; }
      Mod+Period { expel-window-from-column; }

      Mod+R { switch-preset-column-width; }
      Mod+Shift+R { switch-preset-column-width-back; }
      Mod+Ctrl+Shift+R { switch-preset-window-height; }
      Mod+Ctrl+R { reset-window-height; }

      Mod+F { maximize-column; }
      Mod+Shift+F { fullscreen-window; }
      Mod+M { maximize-window-to-edges; }
      Mod+Ctrl+F { expand-column-to-available-width; }
      Mod+C { center-column; }
      Mod+Ctrl+C { center-visible-columns; }

      Mod+Minus { set-column-width "-10%"; }
      Mod+Equal { set-column-width "+10%"; }
      Mod+Shift+Minus { set-window-height "-10%"; }
      Mod+Shift+Equal { set-window-height "+10%"; }

      Mod+V       { toggle-window-floating; }
      Mod+Shift+V { switch-focus-between-floating-and-tiling; }
      Mod+W       { toggle-column-tabbed-display; }

      Print { screenshot; }
      Ctrl+Print { screenshot-screen; }
      Mod+Print { screenshot-window; }

      Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
      Mod+Shift+E { quit; }
      Ctrl+Alt+Delete { quit; }
      Mod+Shift+P { power-off-monitors; }

  ${workspaceBinds}
  ${extraBinds}
  }

  ${extraConfig}
''
