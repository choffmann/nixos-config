# NixOS host configurations. mkHost removes the duplicated specialArgs/lib.extend blocks.
{
  inputs,
  self,
  ...
}: let
  inherit (inputs) nixpkgs;
  mkHost = hostName:
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        outputs = self; # keeps outputs.overlays.* / outputs.nixosModules.* working
        lib = nixpkgs.lib.extend (_: _: {
          custom = import ../lib {inherit (nixpkgs) lib;};
        });
      };
      modules = [../hosts/nixos/${hostName}];
    };
in {
  flake.nixosConfigurations = {
    cho-progeek = mkHost "cho-progeek";
    home-pc = mkHost "home-pc";
  };
}
