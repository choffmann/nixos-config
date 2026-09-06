_: {
  # Runs as a greetd session (greetd itself is enabled by this module) and
  # reuses pkgs.dms-shell, so no separate greeter package or flake input.
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";
  };

  # Keeps a usable TTY to fall back to if the greeter fails to come up.
  boot.kernelParams = [ "console=tty1" ];
}
