{ config, lib, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    font-awesome
    fira-code-symbols
    dejavu_fonts
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "NerdFontsSymbolsOnly" ]; })
    nerdfonts
  ];
}

