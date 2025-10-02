{pkgs, ...}: {
  fonts.packages = with pkgs; [
    poppins
    noto-fonts
    lato
  ];

  environment.systemPackages = with pkgs; [
    libreoffice
  ];
}
