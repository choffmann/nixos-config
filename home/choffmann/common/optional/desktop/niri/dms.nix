{
  pkgs,
  osConfig,
  lib,
  ...
}:
let
  jq = lib.getExe pkgs.jq;
in
{
  # Both files stay writable: DMS persists UI changes into them, and a store
  # symlink would leave its settings dialog permanently unable to save.
  # settings.json is seeded once and then belongs to the user; session.json
  # only gets its wallpaper key refreshed so desktop.wallpaper stays the
  # source for it.
  home.activation.dmsSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    cfg="$HOME/.config/DankMaterialShell"
    run mkdir -p "$cfg"
    if [ ! -e "$cfg/settings.json" ]; then
      run install -m 0644 ${./dms-settings.json} "$cfg/settings.json"
    fi
    # The auth keys are the exception to that: they stay Nix-owned, so the
    # copy greetd takes at boot can't drift from the PAM stacks declared
    # next to them. Overrides whatever the settings dialog last wrote.
    # In "or" mode the lock screen only starts the key from its button or this
    # shortcut, and the combo has to carry Ctrl - the password field matches it
    # inside its ControlModifier branch, so a bare key would never fire.
    # loginctlLockIntegration is what makes the udev rule for a pulled yubikey
    # reach the lock screen at all, so it is pinned here too.
    # The qt templates are off because DMS writes them with literal "\n" and
    # aims them at a KDE scheme qt6ct cannot parse; qt.nix renders ours.
    if ${jq} -e . "$cfg/settings.json" >/dev/null 2>&1; then
      run ${jq} '.enableU2f = true | .u2fMode = "or" | .greeterEnableU2f = true
        | .lockScreenSecurityKeyShortcutEnabled = true
        | .lockScreenSecurityKeyShortcut = "Ctrl+Q"
        | .loginctlLockIntegration = true
        | .matugenTemplateQt5ct = false | .matugenTemplateQt6ct = false' \
        "$cfg/settings.json" > "$cfg/settings.json.new"
      run mv "$cfg/settings.json.new" "$cfg/settings.json"
    fi
  '';

  # config.kdl includes dms/input.kdl, but DMS only writes it once its input
  # page has been opened. Without a seed a fresh machine would boot with no
  # tap-to-click and no natural scrolling at all.
  home.activation.dmsNiriInput = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    dmsKdl="$HOME/.config/niri/dms"
    run mkdir -p "$dmsKdl"
    if [ ! -e "$dmsKdl/input.kdl" ]; then
      run install -m 0644 ${./dms-input.kdl} "$dmsKdl/input.kdl"
    fi
  '';

  home.activation.dmsWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    state="$HOME/.local/state/DankMaterialShell"
    run mkdir -p "$state"
    run ${jq} -n \
      --arg wallpaperPath "${osConfig.desktop.wallpaper}" \
      '$ARGS.named' > "$state/session.json.new"
    # A malformed session.json must not abort activation: DMS itself tolerates
    # that case (falls back to defaults), so treat it the same as absent.
    if [ -f "$state/session.json" ] && ${jq} -e . "$state/session.json" >/dev/null 2>&1; then
      run ${jq} -s '.[0] * .[1]' \
        "$state/session.json" "$state/session.json.new" > "$state/session.json.merged"
      run mv "$state/session.json.merged" "$state/session.json"
      run rm -f "$state/session.json.new"
    else
      run mv "$state/session.json.new" "$state/session.json"
    fi
  '';
}
