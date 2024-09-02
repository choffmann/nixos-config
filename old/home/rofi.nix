{ pkgs, lib, ... }:
{
  programs.rofi = {
    enable = true;

    package = pkgs.rofi-wayland.override { plugins = [ ]; };
    extraConfig = {
      line-margin = 10;

      display-ssh = "";
      display-run = "";
      display-drun = "";
      display-window = "";
      display-combi = "";
      show-icons = true;
    };
    plugins = with pkgs; [ rofi-rbw-wayland ];
    theme = lib.mkForce ./rofi/catppucin-mocha.rsi;
  };
}
