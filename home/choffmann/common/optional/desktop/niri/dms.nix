{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (config.lib.stylix.colors) withHashtag;

  # DMS only reads a custom palette from a file, and only when
  # currentThemeName is exactly "custom".
  themeFile = (pkgs.formats.json { }).generate "dms-stylix-theme.json" {
    dark = {
      name = "Stylix";
      primary = withHashtag.base0D;
      primaryText = withHashtag.base00;
      # Must stay dark: DMS falls primaryContainerText back to surfaceText,
      # so a light container here makes spotlight chips unreadable.
      primaryContainer = withHashtag.base02;
      secondary = withHashtag.base0E;
      surface = withHashtag.base01;
      surfaceText = withHashtag.base05;
      surfaceVariant = withHashtag.base02;
      surfaceVariantText = withHashtag.base05;
      surfaceTint = withHashtag.base0D;
      background = withHashtag.base00;
      backgroundText = withHashtag.base05;
      outline = withHashtag.base03;
      surfaceContainer = withHashtag.base01;
      surfaceContainerHigh = withHashtag.base02;
      error = withHashtag.base08;
      warning = withHashtag.base09;
      info = withHashtag.base0C;
    };
  };

  settings = (pkgs.formats.json { }).generate "dms-settings.json" {
    currentThemeName = "custom";
    customThemeFile = "${themeFile}";
  };
in
{
  xdg.configFile."DankMaterialShell/settings.json".source = settings;

  # session.json stays writable so DMS can persist runtime state; a store
  # symlink here would freeze the light/dark toggle too.
  home.activation.dmsWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    state="$HOME/.local/state/DankMaterialShell"
    run mkdir -p "$state"
    run ${lib.getExe pkgs.jq} -n \
      --arg wallpaperPath "${config.stylix.image}" \
      '$ARGS.named' > "$state/session.json.new"
    # A malformed session.json must not abort activation: DMS itself tolerates
    # that case (falls back to defaults), so treat it the same as absent.
    if [ -f "$state/session.json" ] && ${lib.getExe pkgs.jq} -e . "$state/session.json" >/dev/null 2>&1; then
      run ${lib.getExe pkgs.jq} -s '.[0] * .[1]' \
        "$state/session.json" "$state/session.json.new" > "$state/session.json.merged"
      run mv "$state/session.json.merged" "$state/session.json"
      run rm -f "$state/session.json.new"
    else
      run mv "$state/session.json.new" "$state/session.json"
    fi
  '';
}
