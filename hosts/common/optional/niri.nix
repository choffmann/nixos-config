{ pkgs, ... }:
{
  programs.niri.enable = true;

  # nixpkgs' niri module imports wayland-session.nix with enableXWayland = false,
  # so X11 clients need xwayland-satellite started from the niri config.
  environment.systemPackages = [ pkgs.xwayland-satellite ];

  # The niri module pulls in xdg-desktop-portal-gnome. Without an explicit
  # common default, that second backend changes portal selection for Hyprland too.
  xdg.portal.config.common.default = [ "gtk" ];
}
