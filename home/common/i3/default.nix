{pkgs, ...}:
{
  imports = [ 
    ../rofi
    ../alacritty
  ];

  home.file.".config/i3" = {
    source = ./config;
    recursive = true;
  };
}
