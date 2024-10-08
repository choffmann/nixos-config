{ inputs, lib }:
{
  networking = import ./networking.nix { inherit lib; };

  username = "choffmann";
  handle = "choffmann";
  gitHubEmail = "cedrik.hoffmann@jgdperl.com";
  #domain = inputs.nix-secrets.domain;
  #userFullName = inputs.nix-secrets.full-name;
  #userEmail = inputs.nix-secrets.user-email;
  #workEmail = inputs.nix-secrets.work-email;
  persistFolder = "/persist";
  isMinimal = false; # Used to indicate nixos-installer build
}
