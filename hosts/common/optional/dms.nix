_: {
  programs.dms-shell = {
    enable = true;

    enableSystemMonitoring = true;
    enableVPN = true;
    enableClipboardPaste = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;

    # Pulls in matugen, which derives the shell palette from the wallpaper.
    enableDynamicTheming = true;

    # Default graphical-session.target would also start DMS under Hyprland,
    # where it fights hyprpanel for the notification bus name.
    systemd.target = "niri.service";
  };
}
