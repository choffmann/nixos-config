{
  pkgs,
  inputs,
  config,
  outputs,
  lib,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.sops-nix.nixosModules.sops

    ../../../modules/nixos/common/host-spec.nix
    ../../../modules/nixos/common/wallpaper.nix

    ./nixos.nix
    ./sops.nix
    ./cachix.nix
    ./claude-code.nix
    ../users/choffmann

    ../optional/services/bluetooth.nix
    ../optional/services/mount.nix
    ../optional/services/display-manager/dms-greeter.nix
    ../optional/services/openssh.nix
    ../optional/services/printing.nix
    ../optional/services/xserver.nix
  ];

  networking.hostName = config.hostSpec.hostName;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "bk";

  # list of all packages with their versions
  environment.etc."current-system-packages".text =
    let
      packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
      sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
      formatted = builtins.concatStringsSep "\n" sortedUnique;
    in
    formatted;

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      outputs.overlays.dank-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # See https://jackson.dev/post/nix-reasonable-defaults/
      connect-timeout = 5;
      log-lines = 25;
      min-free = 128000000; # 128MB
      max-free = 1000000000; # 1GB

      trusted-users = [ "@wheel" ];
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      warn-dirty = false;

      allow-import-from-derivation = true;

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      netrc-file = /etc/nix/netrc;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };
}
