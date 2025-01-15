{
  pkgs,
  inputs,
  config,
  ...
}: {
  # TODO: Remove

  imports = [
    ../desktop/wayland
  ];

  # boot = {
  #   extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
  # };

  environment.systemPackages = with pkgs; [
    inputs.ghostty.packages.x86_64-linux.default
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

  security = {
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services = {
    libinput.enable = true;
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
      excludePackages = [pkgs.xterm];
      # videoDrivers = ["nvidia"];
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
    dbus.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    gnome = {
      sushi.enable = true;
      gnome-keyring.enable = true;
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # hardware = {
  #   graphics.enable = true;
  #   nvidia.modesetting.enable = true;
  # };
}
