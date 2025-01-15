{pkgs, ...}: {
  fonts.packages = with pkgs; [
    font-awesome
    fira-code-symbols
    dejavu_fonts
    (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono" "NerdFontsSymbolsOnly"];})
    nerdfonts

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];
}
