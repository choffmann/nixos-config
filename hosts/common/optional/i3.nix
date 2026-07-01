{ pkgs, ... }: {
  environment.pathsToLink = [ "/libexec" ];
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3status
        i3lock
        i3blocks
      ];
    };
  };

  services.xserver.windowManager.i3.package = pkgs.i3-gaps;
  services.displayManager = {
    defaultSession = "none+i3";
  };
  programs.dconf.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };
}
