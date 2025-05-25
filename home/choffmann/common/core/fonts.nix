{
  pkgs,
  lib,
  ...
}: {
  fonts.fontconfig.enable = true;
  home.packages =
    [
      pkgs.noto-fonts
      pkgs.meslo-lgs-nf
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
}
