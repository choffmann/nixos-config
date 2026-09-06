{
  pkgs,
  config,
  ...
}:
let
  homeDir = config.home.homeDirectory;
  workspacesConf = "${homeDir}/.config/hypr/workspaces.conf";
  monitorsConf = "${homeDir}/.config/hypr/monitors.conf";

  hyprFocusToggle = pkgs.writeShellApplication {
    name = "hypr-focus-toggle";
    runtimeInputs = with pkgs; [
      mako
      libnotify
    ];
    text = ''
      if makoctl mode | grep -q "do-not-disturb"; then
        makoctl mode -r do-not-disturb
        notify-send -t 2000 "Focus" "OFF"
      else
        notify-send -t 1000 "Focus" "ON"
        sleep 1
        makoctl mode -a do-not-disturb
      fi
    '';
  };
in
{
  imports = [
    ../wayland-env.nix
    ./rofi
    ./hyprlock.nix
    ./hypridle.nix
    ./waybar.nix
    ./mako.nix
  ];

  home.packages = with pkgs; [
    networkmanagerapplet
    polkit_gnome
    nwg-displays
    nautilus

    brightnessctl
    cliphist
    fuzzel
    grim
    hyprpicker
    imagemagick
    libnotify
    pavucontrol
    playerctl
    swappy
    slurp
    awww
    wayshot
    wlsunset
    wl-clipboard
    wf-recorder
    hyprshot
    satty
  ];

  home.sessionVariables = {
    # wlroots-specific; niri must not inherit this
    WLR_RENDERER = "vulkan";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    systemd.variables = [ "--all" ];

    settings = {
      "$mod" = "ALT";
      "$terminal" = "ghostty";
      "$fileManager" = "$terminal -e yazi";
      "$menu" = "rofi -show drun -show-icons";
      "$editor" = "nvim";
      "$lock" = "hyprlock";

      source = [
        monitorsConf
        workspacesConf
      ];

      xwayland = {
        force_zero_scaling = true;
      };

      exec-once = [
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "nm-applet --indicator"
        "sleep 3 && ${pkgs.synology-drive-client}/bin/synology-drive"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "altgr-intl";
        kb_options = "caps:escape";
        follow_mouse = 1;
        mouse_refocus = false;
        touchpad.natural_scroll = true;
        emulate_discrete_scroll = 0;
      };

      env = [
        "XDG_SESSION_TYPE,wayland"
        "WLR_NO_HARDWARE_CURSOR, 1"
      ];

      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 1;
        layout = "dwindle";
        allow_tearing = true;
      };

      decoration = {
        rounding = 0;
        blur = {
          enabled = false;
        };

        shadow = {
          enabled = false;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92"
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "fluent_decel, 0.1, 1, 0, 1"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
        ];
        animation = [
          "windows, 1, 3, md3_decel, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 2.5, md3_decel"
          "workspaces, 1, 7, fluent_decel, slide"
          "specialWorkspace, 1, 3, md3_decel, slidevert"
        ];
      };

      dwindle = {
        preserve_split = true;
      };

      misc = {
        vrr = 1;
        # layers_hog_mouse_focus = true;
        focus_on_activate = true;
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
        enable_swallow = false;
        swallow_regex = "^($terminal)$";

        disable_hyprland_logo = true;
        force_default_wallpaper = 0;
      };

      # vfr moved from misc to debug in Hyprland 0.55
      debug = {
        vfr = true;
      };

      # monitor = [
      #   "eDP-1,1920x1080@60.0,3440x0,1.0"
      #   "DP-1,3440x1440@59.97,0x0,1.0"
      # ];

      workspace = [
        "special:teams, on-created-empty:/usr/bin/env chromium --profile-directory=Default --app-id=cifhbcnohmdccbgoicgdjpfamggdegmo" # chrome://web-app-internals/
        "special:terminal, on-created-empty:$terminal"
      ];

      # windowrulev2 merged into windowrule in Hyprland 0.55; new match:/effect syntax
      windowrule = [
        # Dialogs
        "match:title ^(Open File)(.*)$, float on"
        "match:title ^(Select a File)(.*)$, float on"
        "match:title ^(Choose wallpaper)(.*)$, float on"
        "match:title ^(Open Folder)(.*)$, float on"
        "match:title ^(Save As)(.*)$, float on"
        "match:title ^(Library)(.*)$, float on"
        "match:title ^(Accounts)(.*)$, float on"

        "match:class ^(galculator)$, float on"
        "match:class ^(waypaper)$, float on"
        "match:class ^(keymapp)$, float on"

        #
        # ========== Always opaque ==========
        #
        "match:class ^([Gg]imp)$, opaque on"
        "match:class ^([Ff]lameshot)$, opaque on"
        "match:class ^([Ii]nkscape)$, opaque on"
        "match:class ^([Bb]lender)$, opaque on"
        "match:class ^([Oo][Bb][Ss])$, opaque on"
        "match:class ^([Ss]team)$, opaque on"
        "match:class ^([Ss]team_app_*)$, opaque on"
        "match:class ^([Vv]lc)$, opaque on"

        # Remove transparency from video
        "match:title ^(Netflix)(.*)$, opaque on"
        "match:title ^(.*YouTube.*)$, opaque on"
        "match:title ^(Picture-in-Picture)$, opaque on"

        # Steam
        "match:title ^()$, match:class ^(steam)$, stay_focused on"
        "match:title ^()$, match:class ^(steam)$, min_size 1 1"

        # Auto-assign apps to workspaces
        "match:class ^(zen-beta|firefox|chromium-browser)$, workspace 2 silent"
        "match:class ^(vesktop|Element)$, workspace 6 silent"
        "match:class ^(thunderbird)$, workspace 7 silent"
        "match:class ^(Spotify)$, workspace 6 silent"
      ];
      layerrule = [
        "match:namespace .*, xray on"
        "match:namespace selection, animation none"
        "match:namespace overview, animation none"
        "match:namespace anyrun, animation none"
        "match:namespace swaylock, blur on"
        "match:namespace eww, blur on"
        "match:namespace eww, ignore_alpha 0.8"
        "match:namespace noanim, animation none"
        "match:namespace noanim, blur on"
        "match:namespace gtk-layer-shell, blur on"
        "match:namespace gtk-layer-shell, ignore_alpha 0"
        "match:namespace launcher, blur on"
        "match:namespace launcher, ignore_alpha 0.5"
        "match:namespace notifications, blur on"
        "match:namespace notifications, ignore_alpha 0.69"
        "match:namespace session, blur on"
        "match:namespace sideright, animation none"
        "match:namespace sideleft, animation none"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod, Z, movewindow"
      ];

      binde = [
        "$mod, Minus, layoutmsg, splitratio -0.1"
        "$mod, Equal, layoutmsg, splitratio 0.1"
        "$mod, Semicolon, layoutmsg, splitratio -0.1"
        "$mod, Apostrophe, layoutmsg, splitratio 0.1"
      ];
      bindle = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        # ",XF86MonBrightnessUp, exec, ags run-js 'brightness.screen_value += 0.05;indicator.popup(1);'"
        # ",XF86MonBrightnessDown, exec, ags run-js 'brightness.screen_value -= 0.05;indicator.popup(1);'"
        # ",XF86MonBrightnessUp, exec, ags run-js 'indicator.popup(1);'"
        # ",XF86MonBrightnessDown, exec, ags run-js 'indicator.popup(1);'"
        # "Alt, I, exec, ydotool key 103:1 103:0 "
        # "Alt, K, exec, ydotool key 108:1 108:0"
        # "Alt, J, exec, ydotool key 105:1 105:0"
        # "Alt, L, exec, ydotool key 106:1 106:0"
      ];

      bindl = [
        ", XF86AudioPlay, exec,  playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec,  playerctl next"
        ", XF86AudioPrev, exec,  playerctl previous"
      ];

      bind = [
        # === Core ===
        "$mod, Return, exec, $terminal"
        "$mod, W, exec, $terminal"
        "$mod, Q, killactive,"
        "$mod, E, exec, $fileManager"
        "$mod, SPACE, exec, $menu"
        "$mod, y, exec, $lock"
        "$mod SHIFT, Q, exit,"

        # === Rofi Modi ===
        "$mod, d, exec, rofi -show drun"
        "$mod, period, exec, rofi -show emoji"
        "$mod, equal, exec, rofi -show calc -no-show-match -no-sort"
        "$mod, o, exec, rofi -show ssh"
        "$mod, b, exec, rofi-rbw"
        "$mod, i, exec, cliphist list | rofi -dmenu -p 'Clipboard' | cliphist decode | wl-copy"

        # === Navigation ===
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"

        # === Move windows ===
        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, j, movewindow, d"
        "$mod SHIFT, k, movewindow, u"

        # === Window state ===
        "$mod, f, fullscreen, 1"
        "$mod SHIFT, f, fullscreen, 0"
        "$mod, v, togglefloating,"
        "$mod, s, layoutmsg, togglesplit"
        "$mod, p, pseudo"

        # === Tabs / Cycle ===
        "$mod, Tab, cyclenext,"
        "$mod SHIFT, Tab, cyclenext, prev"
        "$mod, grave, focuscurrentorlast"

        # === Workspace navigation ===
        "$mod, n, workspace, e+1"
        "$mod SHIFT, n, workspace, e-1"
        "$mod, bracketright, workspace, e+1"
        "$mod, bracketleft, workspace, e-1"

        # === Special workspaces (like vim marks) ===
        "$mod, r, togglespecialworkspace, magic"
        "$mod SHIFT, r, movetoworkspace, special:magic"
        "$mod, t, togglespecialworkspace, teams"
        "$mod SHIFT, t, movetoworkspace, special:teams"
        "$mod, g, togglespecialworkspace, terminal"
        "$mod SHIFT, g, movetoworkspace, special:terminal"

        # === Screenshots ===
        "$mod SHIFT, s, exec, hyprshot -m region"
        "$mod CTRL, s, exec, hyprshot -m output"
        "$mod, c, exec, hyprshot -m window"
        "$mod SHIFT, c, exec, hyprshot -m region --clipboard-only"
        "$mod, a, exec, grim -g \"$(slurp)\" - | satty -f -"

        # === Focus mode ===
        "$mod SHIFT, d, exec, ${hyprFocusToggle}/bin/hypr-focus-toggle"

        # === Submaps (like vim modes) ===
        "$mod, z, submap, resize"
        "$mod, m, submap, move"
        "$mod, x, submap, power"

        # === Mouse ===
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ]
      ++ (
        # workspaces 1-9
        builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          ) 9
        )
      );
    };

    extraConfig = ''
      # === Resize Submap ===
      submap = resize
      binde = , h, resizeactive, -50 0
      binde = , l, resizeactive, 50 0
      binde = , k, resizeactive, 0 -50
      binde = , j, resizeactive, 0 50
      binde = SHIFT, h, resizeactive, -150 0
      binde = SHIFT, l, resizeactive, 150 0
      binde = SHIFT, k, resizeactive, 0 -150
      binde = SHIFT, j, resizeactive, 0 150
      bind = , Return, submap, reset
      bind = , Escape, submap, reset
      bind = , q, submap, reset
      submap = reset

      # === Move Submap ===
      submap = move
      binde = , h, moveactive, -50 0
      binde = , l, moveactive, 50 0
      binde = , k, moveactive, 0 -50
      binde = , j, moveactive, 0 50
      binde = SHIFT, h, moveactive, -150 0
      binde = SHIFT, l, moveactive, 150 0
      binde = SHIFT, k, moveactive, 0 -150
      binde = SHIFT, j, moveactive, 0 150
      bind = , Return, submap, reset
      bind = , Escape, submap, reset
      bind = , q, submap, reset
      submap = reset

      # === Power Submap ===
      submap = power
      bind = , s, exec, systemctl poweroff
      bind = , r, exec, systemctl reboot
      bind = , p, exec, systemctl suspend
      bind = , l, exec, hyprlock
      bind = , e, exit,
      bind = , Return, submap, reset
      bind = , Escape, submap, reset
      bind = , q, submap, reset
      submap = reset
    '';
  };
}
