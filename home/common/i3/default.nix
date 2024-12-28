{pkgs, ...}:
{
  imports = [ 
    ../rofi
    # ../alacritty
    ../ghostty
  ];

  home.file.".config/i3" = {
    source = ./config;
    recursive = true;
  };
}
