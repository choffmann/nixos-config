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

    # Tie the shell's lifecycle to the compositor rather than the broader
    # graphical-session.target, so a niri restart takes DMS with it.
    systemd.target = "niri.service";
  };
}
