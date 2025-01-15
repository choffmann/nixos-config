{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.grim # screen capture component, required by flameshot
  ];
}
