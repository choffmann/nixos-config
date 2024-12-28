{config, pkgs, inputs, ...}:

{
  imports = [
    ../desktop/x11
  ];

  environment.systemPackages = [
    inputs.ghostty.packages.x86_64-linux.default
  ];

  services.xserver = {
    enable = true;
    desktopManager = {xterm.enable=false;};
    displayManager = {
      defaultSession = "none+i3";
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
  programs.dconf.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };
}
