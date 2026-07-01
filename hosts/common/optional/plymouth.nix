{ ... }: {
  boot = {
    kernelParams = [
      "quiet"
      "splash"
    ];
    plymouth.enable = true;
    consoleLogLevel = 0;
    initrd.systemd.enable = true;
  };
}
