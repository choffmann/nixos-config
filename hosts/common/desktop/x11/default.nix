{pkgs, ...}: {
  imports = [
    ../core
  ];

  environment.systemPackages = with pkgs; [
    peek
    flameshot
    rofi
  ];
}
