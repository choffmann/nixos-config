{ pkgs, lib, ... }:
let
  dsearch = pkgs.unstable.dsearch;
in
{
  home.packages = [ dsearch ];

  # DMS's launcher only probes for the binary on PATH, but every query goes
  # through dsearch's local API server, so file results stay empty without it.
  # The nixpkgs derivation ships a unit, yet home-manager never picks units
  # out of packages the way systemd.packages does.
  systemd.user.services.dsearch = {
    Unit = {
      Description = "dsearch filesystem search API";
      Documentation = "https://github.com/AvengeMedia/danksearch";
      After = [ "network.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${lib.getExe dsearch} serve";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    Install.WantedBy = [ "default.target" ];
  };
}
