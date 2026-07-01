{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.unstable.android-studio
    pkgs.unstable.cargo-ndk
    pkgs.libusb1
    pkgs.android-tools
  ];

  users.groups.plugdev = { };
  users.users.choffmann.extraGroups = [ "plugdev" ];

  services.udev.extraRules = ''
    # Samsung (Galaxy S21 Ultra)
    SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="plugdev"
  '';

  boot.blacklistedKernelModules = [ "cdc_acm" ];
}
