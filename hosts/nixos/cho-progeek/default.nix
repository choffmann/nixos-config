# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  outputs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    outputs.nixosModules.yubikey

    inputs.home-manager.nixosModules.default
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix

    # misc
    inputs.stylix.nixosModules.stylix

    # core
    ../../common/core

    # optional
    ../../common/optional/services/mount.nix
    # ../../common/optional/services/greetd.nix
    ../../common/optional/services/gdm.nix
    ../../common/optional/services/openssh.nix
    ../../common/optional/services/printing.nix
    ../../common/optional/services/xserver.nix
    ../../common/optional/audio.nix
    ../../common/optional/hyprland.nix
    ../../common/optional/obsidian.nix
    # ../../common/optional/plymouth.nix
    ../../common/optional/wayland.nix
    ../../common/optional/vlc.nix
    ../../common/optional/yubikey.nix
    ../../common/optional/docker.nix
    ../../common/optional/spotify.nix
  ];

  hostSpec = {
    hostName = "cho-progeek";
    username = "choffmann";
    # useYubiKey = lib.mkForce true;
  };

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
    firewall.enable = false;
  };

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = lib.mkDefault 10;
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
  ];

  environment.variables = {
    EDITOR = "nvim";
  };

  hardware.tuxedo-rs = {
    enable = true;
    tailor-gui.enable = true;
  };

  system.stateVersion = "24.11"; # Did you read the comment?

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    image = ../../../home/wallpaper/progeek/progeek-2.png;
    imageScalingMode = "center";

    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 25;

    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      monospace = {
        package = (
          pkgs.nerdfonts.override {
            fonts = [
              "FiraCode"
              "JetBrainsMono"
              "NerdFontsSymbolsOnly"
            ];
          }
        );
        name = "FiraCode Nerd Font Mono Ret";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };

    fonts.sizes = {
      applications = 10;
      desktop = 10;
      terminal = 10;
      popups = 10;
    };

    opacity = {
      applications = 0.8;
      terminal = 0.8;
      desktop = 1.0;
      popups = 1.0;
    };

    targets.nixvim = {
      plugin = "base16-nvim";
      transparentBackground.main = true;
      transparentBackground.signColumn = true;
    };

    polarity = "dark";
  };
}
