{pkgs, ...}: {
  fonts.packages = with pkgs; [
    poppins
    noto-fonts
  ];

  environment.systemPackages = with pkgs; [
    libreoffice
  ];
}
