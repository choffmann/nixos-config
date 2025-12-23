{
  pkgs,
  lib,
  ...
}: {
  home.file.".local/share/rofi/themes" = {
    source = ./themes;
    recursive = true;
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    pass = {
      enable = true;
      package = pkgs.rofi-pass-wayland;
    };
    extraConfig = {
      modi = "run,drun,window";
      icon-theme = "Oranchelo";
      show-icons = true;
      terminal = "ghostty";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = "   Window";
      display-Network = " 󰤨  Network";
      sidebar-mode = true;
    };
    theme = lib.mkForce "catppuccin-mocha";
  };
}
