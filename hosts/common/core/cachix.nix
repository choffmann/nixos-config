_: {
  nix.settings = {
    substituters = [
      "https://nix-gaming.cachix.org"
      # Nixpkgs-Wayland
      "https://cache.nixos.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://nix-community.cachix.org"
      # green-ecolution
      "https://green-ecolution.cachix.org"
    ];

    trusted-substituters = [ "https://s3.eu-central-3.ionoscloud.com/nix-chrondo-cache" ];
    trusted-public-keys = [
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      # Nixpkgs-Wayland
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      # Nix-community
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # green-ecolution
      "green-ecolution.cachix.org-1:te9SGbuElhDIRHbR4lsUARuqZdf5rkKy2l1Yh03mj6c="

      "nix-chrondo-cache-1:gYbEduoAIymJslfX5IxJBANz6Yk+ZglvCS6OuMv9tAs="
    ];
  };
}
