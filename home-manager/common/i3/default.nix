{pkgs, ...}:
{
  imports = [ 
    ../rofi
  ];

  home.file.".config/i3" = {
    source = ./config;
    recursive = true;
  };
}
