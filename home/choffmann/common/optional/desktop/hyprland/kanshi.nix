{pkgs, ...}: let
  notify = profile: "${pkgs.libnotify}/bin/notify-send -t 3000 'Monitor' '${profile}'";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  restartWaybar = "systemctl --user restart waybar.service";
in {
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "1920x1080@60";
            position = "0,0";
          }
        ];
        profile.exec = [
          "${hyprctl} keyword monitor eDP-1,1920x1080@60,0x0,1"
          restartWaybar
          (notify "Undocked - Laptop")
        ];
      }
      {
        profile.name = "docked-dual";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "1920x1080@60";
            position = "3440,0";
          }
          {
            criteria = "DP-1";
            status = "enable";
            mode = "3440x1440@59.97";
            position = "0,0";
          }
        ];
        profile.exec = [
          "${hyprctl} keyword monitor HDMI-A-1,1920x1080@60,3440x180,1"
          "${hyprctl} keyword monitor eDP-1,1920x1080@60,-1920x0,1"
          restartWaybar
          (notify "Docked - Dual Monitor")
        ];
      }
      {
        profile.name = "docked-single";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "1920x1080@60";
            position = "-1920,0";
          }
          {
            criteria = "DP-1";
            status = "enable";
          }
        ];
        profile.exec = [
          "${hyprctl} keyword monitor eDP-1,1920x1080@60,-1920x0,1"
          restartWaybar
          (notify "Docked - Single Monitor")
        ];
      }
      {
        profile.name = "presentation";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "1920x1080@60";
            position = "0,0";
          }
          {
            criteria = "HDMI-A-1";
            status = "enable";
          }
        ];
        profile.exec = [
          "${hyprctl} keyword monitor HDMI-A-1,preferred,auto,1,mirror,eDP-1"
          restartWaybar
          (notify "Presentation - Mirror")
        ];
      }
    ];
  };
}
