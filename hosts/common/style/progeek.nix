{ pkgs, ... }:
let
  imgPath = ../../../home/choffmann/common/optional/desktops/wallpaper/progeek/progeek-2.png;
in
{
  stylix.enable = true;
  stylix.base16Scheme = {
    base00 = "0F1A21"; # Space Black als Hintergrund
    base01 = "25373B"; # Dunkelgrau
    base02 = "405C61"; # Mittelgrau
    base03 = "5E8186"; # Hellgrau
    base04 = "849A9E"; # Hervorgehobenes Grau
    base05 = "ffffff"; # Weiss als Vordergrund/Standardtext
    base06 = "E3EBEB"; # Heller hervorhebender Ton
    base07 = "F4F4F4"; # Leichtes Weiss
    base08 = "FF8033"; # Primär/Hervorgehobenes Rot, Modifikation von Geeky Orange
    base09 = "ED6B1C"; # Geeky Orange
    base0A = "B8D1DB"; # Highlight Blue #2
    base0B = "4D738A"; # Highlight Blue #1
    base0C = "3A5C70"; # Dunkleres Highlight Blue (Anpassung)
    base0D = "2A4C61"; # Noch dunkleres Highlight Blue (Anpassung)
    base0E = "D06030"; # Ein dunklerer Ton von Geeky Orange (Anpassung)
    base0F = "2B3E44"; # Ein sehr dunkler Ton für spezielle Highlights
  };

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
