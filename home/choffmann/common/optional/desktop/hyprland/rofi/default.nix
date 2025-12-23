{
  pkgs,
  lib,
  ...
}: {
  home.file.".local/share/rofi/themes" = {
    source = ./themes;
    recursive = true;
  };

  home.packages = with pkgs; [
    rofi-calc
    rofi-emoji
    rofi-rbw
    rbw
    pinentry-curses
    wtype
  ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    pass = {
      enable = true;
      package = pkgs.rofi-pass-wayland;
    };
    plugins = with pkgs; [
      rofi-calc
      rofi-emoji
    ];
    extraConfig = {
      modi = "drun,run,window,ssh,calc,emoji";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      terminal = "ghostty";
      drun-display-format = "{name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "λ";
      display-run = "$";
      display-window = "~";
      display-ssh = "@";
      display-calc = "=";
      display-emoji = ":";
      sidebar-mode = true;
      calc-command = "echo -n '{result}' | wl-copy";
      matching = "fuzzy";
      sort = true;
      sorting-method = "fzf";
      kb-row-tab = "";
      kb-element-next = "";
      kb-element-prev = "";
      kb-mode-next = "Tab";
      kb-mode-previous = "Shift+Tab";
    };
    theme = lib.mkForce "terminal";
  };
}
