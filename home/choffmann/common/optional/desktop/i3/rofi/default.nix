{pkgs, ...}: {
  home.file.".local/share/rofi/themes" = {
    source = ./themes;
    recursive = true;
  };

  home.file.".config/rofi/config.rasi" = {
    source = ./config.rasi;
    recursive = true;
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    configPath = "$XDG_CONFIG_HOME/rofi/config.rasi";
  };
}
