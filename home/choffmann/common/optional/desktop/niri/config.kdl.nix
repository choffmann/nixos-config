{
  lib,
  terminal,
  extraConfig,
  extraBinds,
  workspaceOutputs,
  borderActiveColor,
  borderInactiveColor,
}:
let
  # ALT mirrors the Hyprland $mod; niri's own "Mod" would be Super.
  # Workspace references are quoted: a bare integer is an INDEX in niri, but
  # these workspaces are declared by NAME (below), so binds must match by name.
  workspaceBinds = lib.concatMapStringsSep "\n" (n: ''
    Alt+${toString n} { focus-workspace "${toString n}"; }
    Alt+Shift+${toString n} { move-column-to-workspace "${toString n}"; }'') (lib.range 1 9);

  # Numbered workspaces 1-9, shared by both hosts; a host pins one to a
  # specific output via workspaceOutputs (niri rejects a workspace name
  # declared more than once, so this can't be done via a second declaration).
  numberedWorkspaces = lib.concatMapStringsSep "\n" (
    n:
    let
      name = toString n;
      output = workspaceOutputs.${name} or null;
    in
    if output == null then
      ''workspace "${name}"''
    else
      ''
        workspace "${name}" {
            open-on-output "${output}"
        }''
  ) (lib.range 1 9);
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

      mouse {
      }
  }

  layout {
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

  workspace "magic"
  workspace "teams"
  workspace "terminal"

  ${numberedWorkspaces}

  window-rule {
      match app-id=r#"^(zen-beta|firefox|chromium-browser)$"#
      open-on-workspace "2"
  }

  window-rule {
      match app-id=r#"^(vesktop|Element|Spotify)$"#
      open-on-workspace "6"
  }

  window-rule {
      match app-id=r#"^thunderbird$"#
      open-on-workspace "7"
  }

  window-rule {
      match app-id=r#"^chrome-cifhbcnohmdccbgoicgdjpfamggdegmo"#
      open-on-workspace "teams"
  }

  binds {
      Alt+Return { spawn "${terminal}"; }
      Alt+W { spawn "${terminal}"; }
      Alt+E { spawn "${terminal}" "-e" "yazi"; }
      Alt+Q { close-window; }
      Alt+Shift+Q { quit; }

      Alt+Space { spawn "dms" "ipc" "call" "spotlight" "toggle"; }
      Alt+D     { spawn "dms" "ipc" "call" "spotlight" "toggle"; }
      Alt+I     { spawn "dms" "ipc" "call" "clipboard" "toggle"; }
      Alt+Y     { spawn "dms" "ipc" "call" "lock" "lock"; }
      Alt+X     { spawn "dms" "ipc" "call" "powermenu" "toggle"; }
      Alt+U     { spawn "dms" "ipc" "call" "notifications" "toggle"; }

      Alt+H { focus-column-left; }
      Alt+L { focus-column-right; }
      Alt+J { focus-window-down; }
      Alt+K { focus-window-up; }

      Alt+Shift+H { move-column-left; }
      Alt+Shift+L { move-column-right; }
      Alt+Shift+J { move-window-down; }
      Alt+Shift+K { move-window-up; }

      Alt+F { maximize-column; }
      Alt+Shift+F { fullscreen-window; }
      Alt+V { toggle-window-floating; }
      Alt+Tab { focus-workspace-previous; }

      Alt+N { focus-workspace-down; }
      Alt+Shift+N { focus-workspace-up; }
      Alt+BracketLeft { focus-workspace-up; }
      Alt+BracketRight { focus-workspace-down; }

      Alt+Minus { set-column-width "-10%"; }
      Alt+Equal { set-column-width "+10%"; }
      Alt+Semicolon { set-window-height "-10%"; }
      Alt+Apostrophe { set-window-height "+10%"; }

      Alt+Shift+S { screenshot; }
      Alt+Ctrl+S { screenshot-screen; }
      Alt+C { screenshot-window; }

      XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "5%+"; }
      XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
      XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      XF86AudioPlay        allow-when-locked=true { spawn "playerctl" "play-pause"; }
      XF86AudioPause       allow-when-locked=true { spawn "playerctl" "play-pause"; }
      XF86AudioNext        allow-when-locked=true { spawn "playerctl" "next"; }
      XF86AudioPrev        allow-when-locked=true { spawn "playerctl" "previous"; }
      XF86MonBrightnessUp   { spawn "brightnessctl" "set" "5%+"; }
      XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }

      Alt+R       { focus-workspace "magic"; }
      Alt+Shift+R { move-column-to-workspace "magic"; }
      Alt+T       { focus-workspace "teams"; }
      Alt+Shift+T { move-column-to-workspace "teams"; }
      Alt+G       { focus-workspace "terminal"; }
      Alt+Shift+G { move-column-to-workspace "terminal"; }

      Alt+B       { spawn "rofi-rbw"; }
      Alt+Shift+B { spawn "ktt-rofi"; }
      Alt+O       { spawn "rofi" "-show" "ssh"; }
      Alt+Period  { spawn "rofi" "-show" "emoji"; }
      Alt+Shift+Equal { spawn "rofi" "-show" "calc" "-no-show-match" "-no-sort"; }
      Alt+A       { spawn "sh" "-c" "grim -g \"$(slurp)\" - | satty -f -"; }

      Alt+Shift+D { spawn "dms" "ipc" "call" "notifications" "toggleDoNotDisturb"; }

  ${workspaceBinds}
  ${extraBinds}
  }

  ${extraConfig}
''
