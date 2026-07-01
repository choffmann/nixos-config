{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.unstable.rpi-imager ];
}
