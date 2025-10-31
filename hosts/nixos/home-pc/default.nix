# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  outputs,
  lib,
  ...
}: let
  tuneEno1 = pkgs.writeShellScript "tune-eno1" ''
    set -euo pipefail

    PATH=${lib.makeBinPath [pkgs.coreutils pkgs.ethtool pkgs.util-linux pkgs.pciutils]}

    if [ -d /sys/class/net/eno1 ]; then
      # Keep device active (no runtime PM) - critical for stability
      if [ -w /sys/class/net/eno1/device/power/control ]; then
        printf '%s' on | tee /sys/class/net/eno1/device/power/control >/dev/null 2>&1 || true
      fi

      # Enable system wakeup for WoL support
      if [ -w /sys/class/net/eno1/device/power/wakeup ]; then
        printf '%s' enabled | tee /sys/class/net/eno1/device/power/wakeup >/dev/null 2>&1 || true
      fi

      # Disable Energy Efficient Ethernet (EEE) - known to cause issues
      if ethtool --show-eee eno1 >/dev/null 2>&1; then
        ethtool --set-eee eno1 eee off >/dev/null 2>&1 || true
      fi

      # Enable Wake-on-LAN with magic packet
      ethtool -s eno1 wol g 2>/dev/null || true

      # Disable problematic hardware offloading features
      ethtool -K eno1 tso off gso off gro off 2>/dev/null || true

      # Keep tx-nocache-copy on for better performance
      ethtool -K eno1 tx-nocache-copy on 2>/dev/null || true

      # Disable flow control (can cause hangs under load)
      ethtool -A eno1 rx off tx off 2>/dev/null || true

      # Force link speed to 1000 Mbps Full Duplex with autonegotiation
      ethtool -s eno1 speed 1000 duplex full autoneg on 2>/dev/null || true

      # Increase ring buffer sizes for better throughput
      ethtool -G eno1 rx 4096 tx 4096 2>/dev/null || true

      # Adaptive interrupt coalescing
      ethtool -C eno1 adaptive-rx on adaptive-tx on 2>/dev/null || true

      logger -t tune-eno1 "Applied I226-V tuning: stability fixes + WoL enabled"
    fi
  '';
in {
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
    ../../common/optional/office.nix
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

  # Common packages
  environment.systemPackages = with pkgs; [
    unstable.openvpn
    remmina
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  boot.blacklistedKernelModules = ["nvidia" "nouveau"];
  boot.initrd.kernelModules = ["amdgpu"];
  services.xserver.videoDrivers = ["amdgpu"];

  boot.kernelParams = [
    "video=DP-1:3440x1440@59.97300"
    # PCIe power management fixes for I226-V stability
    "pcie_aspm=off"
    "pcie_port_pm=off"
    "pci=noaer"  # Disable PCIe Advanced Error Reporting
    # Intel I226-V driver tuning
    "igc.RSS=1"  # Enable Receive Side Scaling
    "igc.InterruptThrottleRate=3000"  # Adaptive interrupt throttling
  ];

  # Additional kernel modules configuration for I226-V
  boot.extraModprobeConfig = ''
    # Intel I226-V (igc) tuning for stability
    options igc InterruptThrottleRate=3000,3000,3000,3000
    options igc RSS=1,1,1,1
    # Disable MSI-X, use MSI only (sometimes more stable)
    options igc IntMode=1
  '';

  systemd.services.tune-eno1 = {
    description = "Apply Intel I226-V link stability tweaks";
    wantedBy = ["multi-user.target"];
    requires = ["sys-subsystem-net-devices-eno1.device"];
    after = ["sys-subsystem-net-devices-eno1.device"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''${tuneEno1}'';
  };

  # Watchdog service to detect and recover from link failures
  systemd.services.eno1-watchdog = {
    description = "Monitor and recover Intel I226-V network link";
    wantedBy = ["multi-user.target"];
    after = ["network-online.target" "tune-eno1.service"];
    wants = ["network-online.target"];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = "10s";
    };
    script = ''
      PATH=${lib.makeBinPath [pkgs.coreutils pkgs.iproute2 pkgs.ethtool]}

      while true; do
        sleep 30

        # Check if interface exists and is up
        if [ -d /sys/class/net/eno1 ]; then
          # Check carrier status
          carrier=$(cat /sys/class/net/eno1/carrier 2>/dev/null || echo "0")
          operstate=$(cat /sys/class/net/eno1/operstate 2>/dev/null || echo "down")

          if [ "$carrier" = "0" ] || [ "$operstate" = "down" ]; then
            logger -t eno1-watchdog "WARNING: Link down detected (carrier=$carrier, state=$operstate)"

            # Try to recover by bouncing the interface
            ip link set eno1 down 2>/dev/null || true
            sleep 2
            ip link set eno1 up 2>/dev/null || true

            # Reapply tuning after recovery
            ${tuneEno1} || true

            logger -t eno1-watchdog "Recovery attempted for eno1"
          fi
        fi
      done
    '';
  };

  services.udev.extraRules = ''
    # Apply tuning on interface add
    ACTION=="add", SUBSYSTEM=="net", KERNEL=="eno1", RUN+="${tuneEno1}"

    # Reapply tuning on carrier change
    ACTION=="change", SUBSYSTEM=="net", KERNEL=="eno1", RUN+="${tuneEno1}"
  '';
  services.udev.packages = [pkgs.usbutils];

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
