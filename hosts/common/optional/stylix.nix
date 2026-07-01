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
    imageScalingMode = "center";

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

    fonts.sizes = {
      applications = 10;
      desktop = 10;
      terminal = 10;
      popups = 10;
    };

    opacity = {
      applications = 0.8;
      terminal = 0.8;
      desktop = 1.0;
      popups = 0.8;
    };

    targets.nixvim = {
      plugin = "base16-nvim";
      transparentBackground.main = true;
      transparentBackground.signColumn = true;
    };

    polarity = "dark";
  };
}
