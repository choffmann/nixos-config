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

  # DMS keeps qt5ct.conf/qt6ct.conf pointed at its matugen palette, but only
  # the qtct platform theme makes Qt applications read them. stylix set this
  # before its targets were turned off.
  qt = {
    enable = true;
    platformTheme = "qt5ct"; # nixpkgs' name for qtct; covers qt6ct as well
  };
}
