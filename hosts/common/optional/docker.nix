{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  systemd.sockets.docker.wantedBy = ["sockets.target"];
}
