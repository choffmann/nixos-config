{ pkgs, ... }: {
  services = {
    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
  };

  yubikey = {
    enable = true;
    identifiers = {
      yubi = 30641754;
    };
  };
}
