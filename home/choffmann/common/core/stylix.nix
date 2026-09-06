_: {
  # stylix.autoEnable is off system-wide so DMS/matugen owns the GUI. matugen
  # has no templates for the terminal tools, so stylix keeps those.
  stylix.targets = {
    fontconfig.enable = true;

    bat.enable = true;
    btop.enable = true;
    fzf.enable = true;
    k9s.enable = true;
    lazygit.enable = true;
    starship.enable = true;
    yazi.enable = true;
  };
}
