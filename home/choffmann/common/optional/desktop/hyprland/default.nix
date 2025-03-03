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
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        enable_swallow = true;
        swallow_regex = "^($terminal)$";
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

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      binde = [
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
          "$mod, SHIFT I, fullscreen, 0"
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

          ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
          ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl previous"
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
