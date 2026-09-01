# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  outputs,
  lib,
  config,
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

    # core
    ../../common/core

    # optional
    ../../common/optional/stylix.nix
    ../../common/optional/vpn.nix
    ../../common/optional/office.nix
    ../../common/optional/android.nix
    ../../common/optional/audio.nix
    ../../common/optional/hyprland.nix
    ../../common/optional/desktop-apps.nix
    ../../common/optional/plymouth.nix
    ../../common/optional/wayland.nix
    ../../common/optional/yubikey.nix
    ../../common/optional/docker.nix
    ../../common/optional/spotify.nix
    ../../common/optional/memory-management.nix
    ../../common/optional/k8s.nix
    ../../common/optional/fonts.nix
    ../../common/optional/postgresql.nix
  ];

  hostSpec = {
    hostName = "cho-progeek";
    username = "choffmann";
    # useYubiKey = lib.mkForce true;
  };

  sops.secrets."wifi/progeek-office" = {};

  networking = {
    networkmanager = {
      enable = true;
      ensureProfiles.profiles.progeek-office = {
        connection = {
          id = "PROGEEK-OFFICE";
          type = "wifi";
          autoconnect = "false";
        };
        wifi = {
          ssid = "PROGEEK-OFFICE";
          mode = "infrastructure";
        };
        wifi-security = {
          key-mgmt = "wpa-eap";
        };
        "802-1x" = {
          eap = "ttls;";
          phase2-auth = "pap";
          identity = "choffmann";
          password = "$WIFI_PROGEEK_OFFICE_PW";
          password-flags = "0";
        };
      };
      ensureProfiles.environmentFiles = [
        config.sops.secrets."wifi/progeek-office".path
      ];
    };
    enableIPv6 = false;
    firewall.enable = false;
  };

  environment = {
    systemPackages = with pkgs; [
      qemu
      quickemu
    ];
  };

  systemd.tmpfiles.rules = ["L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = lib.mkDefault 10;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  boot.plymouth = {
    theme = lib.mkForce "progeek_loading";
    themePackages = [inputs.progeek-plymouth.packages.${pkgs.stdenv.hostPlatform.system}.default];
  };

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  hardware.tuxedo-rs = {
    enable = true;
    tailor-gui.enable = true;
  };

  system.stateVersion = "24.11"; # Did you read the comment?

  stylix.image = ../../../home/wallpaper/progeek/progeek-2.png;
}
