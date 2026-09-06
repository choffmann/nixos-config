{ config, ... }:
let
  palette = "${config.xdg.configHome}/qt6ct/colors/dms-matugen.conf";
in
{
  # DMS merges every toml here into its generated matugen config verbatim,
  # without the SHELL_DIR/CONFIG_DIR substitution its own configs get, so
  # these paths have to be absolute.
  xdg.configFile."matugen/dms/configs/qt6ct.toml".text = ''
    [templates.qt6ct]
    input_path = '${./qt-colors.conf}'
    output_path = '${palette}'
  '';

  # DMS' own qt5ct/qt6ct templates are switched off in dms.nix, so this file
  # is ours: they write literal "\n" instead of newlines, which leaves the
  # real keys outside any section header, and point color_scheme_path at the
  # KDE .colors scheme that qt6ct cannot parse.
  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    custom_palette=true
    color_scheme_path=${palette}
    style=Fusion
    standard_dialogs=default

    [Fonts]
    general="Noto Sans,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
    fixed="JetBrainsMono NF,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
  '';
}
