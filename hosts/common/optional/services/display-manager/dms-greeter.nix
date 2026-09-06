_: {
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";

    configHome = "/home/choffmann";

    configFiles = [
      "/home/choffmann/.config/DankMaterialShell/settings.json"
    ];
  };

  # Keeps a usable TTY to fall back to if the greeter fails to come up.
  boot.kernelParams = [ "console=tty1" ];
}
