{
  config,
  lib,
  pkgs,
  ...
}:
{
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

  # The lock screen looks the security-key stack up by this exact filename;
  # without it DMS falls back to one bundled in its own store path, which
  # never reaches the key. Auth only — the password stack stays separate.
  security.pam.services."dankshell-u2f".text = ''
    auth    required ${pkgs.pam_u2f}/lib/security/pam_u2f.so cue
    account required ${config.security.pam.package}/lib/security/pam_permit.so
  '';

  # Only the qtct platform theme makes Qt applications read the matugen
  # palette. stylix set this before its targets were turned off.
  qt = {
    enable = true;
    platformTheme = "qt5ct"; # installs both qtct plugins; see the override below
  };

  # libqt6ct registers under the key "qt6ct" alone, so "qt5ct" reaches no Qt6
  # application - and every Qt GUI here is Qt6 except VLC. The option itself
  # offers no "qt6ct" value, hence the override rather than a nicer setting.
  environment.variables.QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
}
