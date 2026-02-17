{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    obsidian
    vlc
    prusa-slicer
  ];
}
