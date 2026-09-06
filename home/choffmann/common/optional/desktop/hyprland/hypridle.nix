_: {
  services.hypridle = {
    enable = true;
    # Bind to Hyprland's own target, not the shared graphical-session.target
    # that niri's niri.service also activates.
    systemdTarget = "hyprland-session.target";
    settings = {
      general = {
        before_sleep_cmd = "loginctl lock-session ";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };
      listener = [
        {
          timeout = 300; # 5min
          on-timeout = "hyprlock";
        }
        {
          timeout = 900; # 15min
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800; # 30min
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
