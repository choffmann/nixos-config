{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    ../desktop/wayland
  ];

  boot = {
    extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
  };

  environment.systemPackages = with pkgs; [
    libva-utils
    fuseiso
    udiskie
    adwaita-icon-theme
    gnome-themes-extra
    # nvidia-vaapi-driver
    wl-clipboard
    hyprland-protocols
    hyprpicker
    xdg-desktop-portal-hyprland
    hyprpaper
    grim
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk

    qt5.qtwayland
    qt6.qmake
    qt6.qtwayland
    adwaita-qt
    adwaita-qt6

    mako
    libnotify
    wlogout

    hyprlock
    hyprshot

    rofi-wayland
  ];

  services = {
    libinput.enable = true;
    dbus.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
  };
}
