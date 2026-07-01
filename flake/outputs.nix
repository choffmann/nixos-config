# Non-host flake outputs: overlays, reusable nixos modules, per-system packages + formatter.
{ inputs, ... }: {
  flake = {
    overlays = import ../overlays { inherit inputs; };
    nixosModules = import ../modules/nixos;
  };

  perSystem = { pkgs, ... }: {
    packages = import ../pkgs pkgs;
  };
}
