{pkgs, inputs, ...}: {
  imports = [
    ../rofi
    # ../alacritty
    ../ghostty
  ];

  home.packages = with pkgs; [
    networkmanagerapplet
    polkit_gnome
    nwg-displays
    hyprpanel
  ];

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "../../wallpaper/vibrant-landscape.jpg" ];
    };
  };

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
      exec-once = [
        "${pkgs.hyprpanel}/bin/hyprpanel"
        "${pkgs.hyprpaper}/bin/hyprpaper"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "nm-applet --indicator"
      ];
      "$mod" = "ALT";
      "$terminal" = "ghostty";
      "$fileManager" = "nautilus";
      "$menu" = "rofi -show drun -show-icons";
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

      monitor = [
        "HDMI-A-1,1920x1080@60.0,3440x0,1.0"
        "HDMI-A-1,transform,3"
        "DP-3,3440x1440@59.97,0x0,1.0"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      debug = {
        disable_logs = false;
      };

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
          "$mod, mouse_down, workspace, e+1" # Scroll through existing workspaces with mainMod + scroll
          "$mod, mouse_down, workspace, e-2" # Scroll through existing workspaces with mainMod + scroll
          "$mod, r, togglespecialworkspace, magic"
          "$mod SHIFT, r, movetoworkspace, special:magic"
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, j, movefocus, d"
          "$mod, k, movefocus, u"
          "$mod, SHIFT h, movefocus, l"
          "$mod, SHIFT l, movefocus, r"
          "$mod, SHIFT j, movefocus, d"
          "$mod, SHIFT k, movefocus, u"
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
