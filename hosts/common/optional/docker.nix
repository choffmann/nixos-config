{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  environment.systemPackages = [pkgs.docker-buildx];

  systemd.sockets.docker.wantedBy = ["sockets.target"];
}
