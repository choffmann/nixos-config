{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; 

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Stylix
    stylix.url = "github:danth/stylix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    ...
  } @ inputs:
    let
      inherit (self) outputs;
      username = "choffmann";
    in {
      nixosConfigurations = {
        vm = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit stylix inputs username outputs;};
          modules = [
            stylix.nixosModules.stylix
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

        macbook = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs username outputs;};
          modules = [
            ./hosts/macbook/configuration.nix
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users."${username}" = import ./hosts/macbook/home.nix;

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
