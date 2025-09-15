# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    outputs.nixosModules.yubikey

    inputs.home-manager.nixosModules.default
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix

    # misc
    inputs.stylix.nixosModules.stylix

    # core
    ../../common/core

    # optional
    ../../common/optional/vpn.nix
    ../../common/optional/services/bluetooth.nix
    ../../common/optional/services/mount.nix
    ../../common/optional/services/display-manager/greetd.nix
    ../../common/optional/services/openssh.nix
    ../../common/optional/services/printing.nix
    ../../common/optional/services/xserver.nix
    ../../common/optional/services/logitech-mx.nix
    ../../common/optional/audio.nix
    ../../common/optional/hyprland.nix
    ../../common/optional/obsidian.nix
    ../../common/optional/pi.nix
    # ../../common/optional/plymouth.nix
    ../../common/optional/wayland.nix
    ../../common/optional/vlc.nix
    ../../common/optional/yubikey.nix
    ../../common/optional/docker.nix
    ../../common/optional/spotify.nix
    ../../common/optional/passthrough-gpu.nix
    ../../common/optional/prusa.nix
    ../../common/optional/steam.nix
    ../../common/optional/android.nix
  ];

  hostSpec = {
    hostName = "home-pc";
    username = "choffmann";
    # useYubiKey = lib.mkForce true;
  };

  # greetd options
  autoLogin = {
    enable = true;
    username = "choffmann";
  };

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
    firewall.enable = false;

    interfaces = {
      eno1.wakeOnLan.enable = true;
    };

    hosts = {
      "192.168.122.192" = ["naboo" "naboo.local"];
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  boot.blacklistedKernelModules = ["nvidia" "nouveau"];
  boot.initrd.kernelModules = ["amdgpu"];
  services.xserver.videoDrivers = ["amdgpu"];

  boot.kernelParams = [
    "video=DP-1:3440x1440@59.97300"
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 4;
      graphics = false;
    };
  };

  services.fwupd.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11"; # Did you read the comment?

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    image = ../../../home/wallpaper/madeira.jpeg;
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
          pkgs.nerd-fonts.fira-code
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
