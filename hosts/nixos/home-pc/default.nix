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

    # core
    ../../common/core

    # optional
    ../../common/optional/stylix.nix
    ../../common/optional/vpn.nix
    ../../common/optional/services/logitech-mx.nix
    ../../common/optional/audio.nix
    ../../common/optional/hyprland.nix
    ../../common/optional/desktop-apps.nix
    ../../common/optional/office.nix
    ../../common/optional/pi.nix
    ../../common/optional/plymouth.nix
    ../../common/optional/wayland.nix
    ../../common/optional/yubikey.nix
    ../../common/optional/docker.nix
    ../../common/optional/spotify.nix
    ../../common/optional/passthrough-gpu.nix
    ../../common/optional/steam.nix
    ../../common/optional/android.nix
    ../../common/optional/winbox.nix
    ../../common/optional/vm-bridge.nix
    ../../common/optional/fonts.nix
    ../../common/optional/postgresql.nix
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
    networkmanager = {
      enable = true;
    };
    modemmanager.enable = false;
    enableIPv6 = false;
    firewall.enable = false;

    hosts = {
      "192.168.122.192" = ["naboo" "naboo.local"];
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  systemd.settings.Manager = {
    DefaultTimeoutStartSec = "30s";
    DefaultTimeoutStopSec = "15s";
  };

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
      # 511M ESP can't hold 10 generations once initrds grow (kernel 6.18.x).
      configurationLimit = 5;
      editor = false;
    };
    efi.canTouchEfiVariables = true;
  };
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  boot.plymouth = {
    theme = lib.mkForce "lone";
    themePackages = [
      (pkgs.adi1090x-plymouth-themes.override {selected_themes = ["lone"];})
    ];
  };

  boot.blacklistedKernelModules = ["nvidia" "nouveau"];
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelModules = ["hid-logitech-dj" "hid-logitech-hidpp"];
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
    # Reduce USB enumeration timeout for defective port 1-11 (default 5000ms)
    "usbcore.initial_descriptor_timeout=500"
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

    # Disable defective USB port 1-11 to prevent 60s boot delay
    ACTION=="add", SUBSYSTEM=="usb", DEVPATH=="*/usb1/1-11", ATTR{authorized}="0"
  '';
  services.udev.packages = [pkgs.usbutils];

  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 4;
      graphics = false;
    };
  };

  services.fwupd.enable = true;

  system.stateVersion = "24.11"; # Did you read the comment?

  stylix.image = ../../../home/wallpaper/madeira.jpeg;
}
