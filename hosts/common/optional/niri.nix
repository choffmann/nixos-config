{ pkgs, ... }:
{
  programs.niri.enable = true;

  # Stable and unstable both sit on 26.04 today; taking the unstable package
  # means the next niri release arrives with a plain `nix flake update`.
  programs.niri.package = pkgs.unstable.niri;

  # nixpkgs' niri module imports wayland-session.nix with enableXWayland = false,
  # so X11 clients need xwayland-satellite started from the niri config.
  environment.systemPackages = [ pkgs.xwayland-satellite ];

  # The niri module pulls in xdg-desktop-portal-gnome. Prefer gtk for anything
  # not covered by its own `xdg.portal.config.niri` block.
  xdg.portal.config.common.default = [ "gtk" ];
}
