{pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    satty
    nautilus
    vlc
  ];
}
