{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs:
    let
      inherit (self) outputs;
      username = "choffmann";
    in {
      nixosConfigurations = {
        vm = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs username outputs;};
          modules = [
            ./hosts/vm/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users."${username}" = import ./hosts/vm/home.nix;

                extraSpecialArgs = {
                  inherit username;
                };
              };
            }
          ];
        };
      };
    };
}
