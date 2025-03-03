{
  pkgs,
  config,
  ...
}: let
  homeDir = config.home.homeDirectory;
  workspacesConf = "${homeDir}/.config/hypr/workspaces.conf";
  monitorsConf = "${homeDir}/.config/hypr/monitors.conf";
in {
  imports = [
    ./rofi
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprpanel.nix
  ];

  home.packages = with pkgs; [
    networkmanagerapplet
    polkit_gnome
    nwg-displays
    nautilus

    hyprshot
    satty
  ];

  home.sessionVariables = {
    GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    CLUTTER_BACKEND = "wayland";
    WLR_RENDERER = "vulkan";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    GTK_USE_PORTAL = "1";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    systemd.variables = ["--all"];

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
        # "${lib.getExe inputs.ags-bar.packages."x86_64-linux".default}"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "nm-applet --indicator"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "altgr-intl";
        kb_options = "caps:escape";
        follow_mouse = 1;
        mouse_refocus = false;
        touchpad.natural_scroll = true;
      };

      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "WLR_NO_HARDWARE_CURSOR, 1"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle";
      };

      decoration = {
        rounding = 5;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          new_optimizations = true;
        };

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          # color = "rgba(1a1a1aee)";
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
          # "workspaces, 1, 3.5, md3_decel, slide"
          "workspaces, 1, 7, fluent_decel, slide"
          # "workspaces, 1, 7, fluent_decel, slidefade 15%"
          # "specialWorkspace, 1, 3, md3_decel, slidefadevert 15%"
          "specialWorkspace, 1, 3, md3_decel, slidevert"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        vfr = 1;
        vrr = 1;
        # layers_hog_mouse_focus = true;
        focus_on_activate = true;
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
        enable_swallow = false;
        swallow_regex = "^($terminal)$";

        disable_hyprland_logo = true;
        force_default_wallpaper = 0;
        new_window_takes_over_fullscreen = 2;
      };

      # monitor = [
      #   "eDP-1,1920x1080@60.0,3440x0,1.0"
      #   "DP-1,3440x1440@59.97,0x0,1.0"
      # ];

      workspace = [
        "special:teams, on-created-empty:/usr/bin/env chromium --profile-directory=Default --app-id=cifhbcnohmdccbgoicgdjpfamggdegmo" # chrome://web-app-internals/
        "special:terminal, on-created-empty:$terminal"
      ];

      windowrule = [
        # Dialogs
        "float, title:^(Open File)(.*)$"
        "float, title:^(Select a File)(.*)$"
        "float, title:^(Choose wallpaper)(.*)$"
        "float, title:^(Open Folder)(.*)$"
        "float, title:^(Save As)(.*)$"
        "float, title:^(Library)(.*)$"
        "float, title:^(Accounts)(.*)$"
      ];
      windowrulev2 = [
        "float, class:^(galculator)$"
        "float, class:^(waypaper)$"
        "float, class:^(keymapp)$"

        #
        # ========== Always opaque ==========
        #
        "opaque, class:^([Gg]imp)$"
        "opaque, class:^([Ff]lameshot)$"
        "opaque, class:^([Ii]nkscape)$"
        "opaque, class:^([Bb]lender)$"
        "opaque, class:^([Oo][Bb][Ss])$"
        "opaque, class:^([Ss]team)$"
        "opaque, class:^([Ss]team_app_*)$"
        "opaque, class:^([Vv]lc)$"

        # Remove transparency from video
        "opaque, title:^(Netflix)(.*)$"
        "opaque, title:^(.*YouTube.*)$"
        "opaque, title:^(Picture-in-Picture)$"
      ];
      layerrule = [
        "xray 1, .*"
        "noanim, selection"
        "noanim, overview"
        "noanim, anyrun"
        "blur, swaylock"
        "blur, eww"
        "ignorealpha 0.8, eww"
        "noanim, noanim"
        "blur, noanim"
        "blur, gtk-layer-shell"
        "ignorezero, gtk-layer-shell"
        "blur, launcher"
        "ignorealpha 0.5, launcher"
        "blur, notifications"
        "ignorealpha 0.69, notifications"
        "blur, session"
        "noanim, sideright"
        "noanim, sideleft"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod, Z, movewindow"
      ];

      binde = [
        "$mod, Minus, splitratio, -0.1"
        "$mod, Equal, splitratio, 0.1"
        "$mod, Semicolon, splitratio, -0.1"
        "$mod, Apostrophe, splitratio, 0.1"
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

      bind =
        [
          "$mod, W, exec, $terminal"
          "$mod, Q, killactive,"
          "$mod, M, exit,"
          "$mod, E, exec, $fileManager"
          "$mod, V, togglefloating,"
          "$mod, SPACE, exec, $menu"
          "$mod, I, fullscreen, 1"
          "$mod SHIFT, I, fullscreen, 0"
          "$mod, S, togglesplit"
          "$mod, P, pseudo"
          "$mod, mouse_down, workspace, e+1" # Scroll through existing workspaces with mainMod + scroll
          "$mod, mouse_down, workspace, e-2" # Scroll through existing workspaces with mainMod + scroll
          "$mod, r, togglespecialworkspace, magic"
          "$mod SHIFT, r, movetoworkspace, special:magic"

          "$mod, T, togglespecialworkspace, teams"
          "$mod SHIFT, T, movetoworkspace, special:teams"

          "$mod, G, togglespecialworkspace, terminal"
          "$mod SHIFT, G, movetoworkspace, special:terminal"

          "$mod, y, exec, $lock"

          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, j, movefocus, d"
          "$mod, k, movefocus, u"

          "$mod, B, togglespecialworkspace, magic"
          "$mod, B, movetoworkspace, +0"
          "$mod, B, togglespecialworkspace, magic"
          "$mod, B, movetoworkspace, special:magic"
          "$mod, B, togglespecialworkspace, magic"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );
    };
  };
}
