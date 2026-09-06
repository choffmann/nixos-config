{ pkgs, ... }:
{
  environment.sessionVariables = {
    QT_QPA_PLATFORM = "xcb";
  };

  environment.systemPackages = with pkgs; [
    grim # screen capture component, required by flameshot

    grimblast
    satty

    qt5.qtwayland
    qt6.qmake
    qt6.qtwayland
    adwaita-qt
    adwaita-qt6
  ];

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
