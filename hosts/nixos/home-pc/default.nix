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

      # Disable Energy Efficient Ethernet (EEE) - known to cause issues with I226-V
      if ethtool --show-eee eno1 >/dev/null 2>&1; then
        ethtool --set-eee eno1 eee off >/dev/null 2>&1 || true
      fi

      # Enable Wake-on-LAN with magic packet
      ethtool -s eno1 wol g 2>/dev/null || true

      logger -t tune-eno1 "Applied I226-V tuning: Power management disabled, EEE off, WoL enabled"
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
    ./hardware-optimization.nix

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

  # Storage drives
  fileSystems."/storage/hdd" = {
    device = "/dev/disk/by-uuid/1e8c6e42-ff5d-4e65-ae84-e32966009035";
    fsType = "ext4";
    options = ["defaults" "nofail" "exec" "x-gvfs-show"];
  };

  fileSystems."/storage/ssd" = {
    device = "/dev/disk/by-uuid/bc11b81d-5a1b-42b4-bcd7-fbf80dd6635e";
    fsType = "ext4";
    options = ["defaults" "nofail" "exec" "x-gvfs-show"];
  };

  networking = {
    networkmanager.enable = true;
    modemmanager.enable = false;
    enableIPv6 = false;
    firewall.enable = false;

    interfaces = {
      eno1.wakeOnLan.enable = true;
    };

    hosts = {
      "192.168.122.192" = ["naboo" "naboo.local"];
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  systemd.extraConfig = ''
    DefaultTimeoutStartSec=30s
    DefaultTimeoutStopSec=15s
  '';

  systemd.services.systemd-udev-settle.enable = false;

  # Common packages
  environment.systemPackages = with pkgs; [
    unstable.openvpn
    remmina
  ];

  # Bootloader.
  boot.loader = {
    timeout = 1;
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
      editor = false;
    };
    efi.canTouchEfiVariables = true;
  };
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  boot.blacklistedKernelModules = ["nvidia" "nouveau"];
  boot.initrd.kernelModules = ["amdgpu"];
  services.xserver.videoDrivers = ["amdgpu"];

  boot.kernelParams = [
    "video=DP-1:3440x1440@59.97300"
    "pcie_aspm=off"
    "nvme_core.default_ps_max_latency_us=0"
    "quiet"
    "nowatchdog"
    "loglevel=3"
    "rd.systemd.show_status=auto"
    "rd.udev.log_level=3"
  ];

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
