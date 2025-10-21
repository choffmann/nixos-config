{pkgs, ...}: {
  environment.systemPackages = [pkgs.unstable.android-studio pkgs.unstable.cargo-ndk pkgs.libusb1];

  programs.adb.enable = true;
  users.groups.plugdev = {};
  users.users.choffmann.extraGroups = ["adbusers" "plugdev"];

  services.udev.extraRules = ''
    # Samsung (Galaxy S21 Ultra)
    SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="plugdev"
  '';

  boot.blacklistedKernelModules = ["cdc_acm"];
}
