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
    if ${jq} -e . "$cfg/settings.json" >/dev/null 2>&1; then
      run ${jq} '.enableU2f = true | .u2fMode = "or" | .greeterEnableU2f = true' \
        "$cfg/settings.json" > "$cfg/settings.json.new"
      run mv "$cfg/settings.json.new" "$cfg/settings.json"
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
