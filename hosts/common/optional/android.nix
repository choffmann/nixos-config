{pkgs, ...}: {
  environment.systemPackages = [pkgs.unstable.android-studio pkgs.unstable.cargo-ndk];

  programs.adb.enable = true;
  users.users.choffmann.extraGroups = ["adbusers"];
}
