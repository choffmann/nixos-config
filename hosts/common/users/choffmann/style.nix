{ pkgs, ... }:
let
  imgPath = ../../../../home/choffmann/common/optional/desktops/wallpaper/progeek/progeek-2.png;
in
{
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  stylix.image = imgPath;

  stylix.cursor.package = pkgs.bibata-cursors;
  stylix.cursor.name = "Bibata-Modern-Ice";

  stylix.fonts = {
    serif = {
      package = pkgs.noto-fonts;
      name = "Noto Serif";
    };

    sansSerif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };

    monospace = {
      package = (
        pkgs.nerdfonts.override {
          fonts = [
            "FiraCode"
            "JetBrainsMono"
            "NerdFontsSymbolsOnly"
          ];
        }
      );
      name = "FiraCode Nerd Font Mono Ret";
    };

    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };

  stylix.fonts.sizes = {
    applications = 12;
    desktop = 10;
    terminal = 10;
    popups = 10;
  };

  stylix.opacity = {
    applications = 1.0;
    terminal = 0.8;
    desktop = 1.0;
    popups = 1.0;
  };

  stylix.polarity = "dark";
}
