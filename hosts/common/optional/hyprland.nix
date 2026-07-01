{ pkgs, ... }: {
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
}
