{
  description = "Cedrik Hoffmanns NixOS/home-manager Flake (cho-progeek, home-pc)";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";

    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix/release-26.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # neovim.url = "github:choffmann/nixvim";
    ags-bar.url = "github:choffmann/ags-bar";
    ags-bar.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    # Logitech MX
    solaar.url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz";
    solaar.inputs.nixpkgs.follows = "nixpkgs";

    k8s-oidc-auth.url = "git+ssh://git@gitlab.progeek.de:2200/progeek/k8s-oidc-auth";
    k8s-oidc-auth.inputs.nixpkgs.follows = "nixpkgs";

    progeek-plymouth.url = "github:choffmann/progeek-loading-plymouth-theme";
    progeek-plymouth.inputs.nixpkgs.follows = "nixpkgs";

    yazi-plugins.url = "github:yazi-rs/plugins";
    yazi-plugins.flake = false;

    ktt.url = "git+ssh://git@gitlab.progeek.de:2200/choffmann/kimai-time-tracker.git";
    ktt.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.git-hooks.flakeModule
        ./flake/hosts.nix
        ./flake/outputs.nix
        ./flake/dev.nix
        ./flake/checks.nix
      ];
    };
}
