_: {
  programs.dms-shell = {
    enable = true;

    enableSystemMonitoring = true;
    enableVPN = true;
    enableClipboardPaste = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;

    # stylix owns the palette; matugen would fight it for control of the colours.
    enableDynamicTheming = false;
  };
}
