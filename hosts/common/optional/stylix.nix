{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    base16Scheme = ../../../themes/terminal-aesthetic.yaml;

    # Application theming belongs to DMS, which regenerates it from the
    # wallpaper via matugen at runtime. Its GTK and Qt helpers skip any file
    # they cannot write, so a stylix-managed store symlink silently disables
    # them. This propagates to home-manager through stylix's followSystem.
    autoEnable = false;

    targets = {
      console.enable = true;
      font-packages.enable = true;
      fontconfig.enable = true;
    };

    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 25;

    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    polarity = "dark";
  };
}
