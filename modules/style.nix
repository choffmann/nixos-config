{pkgs, username, ...}:
let
  projectPath = "/home/${username}/.config/nixos-config";
in
{
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  stylix.polarity = "dark";

  stylix.image = "${projectPath}/home/wallpaper/progeek/progeek-2.png";

}
