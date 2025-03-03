{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    qt5.qtwayland
    qt6.qmake
    qt6.qtwayland
    adwaita-qt
    adwaita-qt6
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG Portals
  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
}
