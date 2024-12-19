{ pkgs, ...}:
{
  home.file.".config/rofi/catppuccin-mocha.rasi" = {
    source = ./catppuccin-mocha.rasi;
  };

  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "run,drun,window";
      font = "Noto Sans CJK JP 12";
      show-icons = true;
      disable-history = true;
      hover-select = true;
      bw = 0;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = "   Window";
      display-network = "   Network";
      icon-theme = "Oranchelo";
      terminal = "alacritty";
      drun-match-fields = "name";
      drun-display-format = "{icon} {name}";
      me-select-entry = "";
      me-accept-entry = "MousePrimary";
      kb-cancel = "Escape,MouseMiddle";
    };
    theme = "catppuccin-mocha";
  };
}
