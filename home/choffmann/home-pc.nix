{...}: {
  imports = [
    ./common/core

    ./common/optional/k8s.nix
    ./common/optional/sops.nix
    ./common/optional/discord.nix
    ./common/optional/brower
    ./common/optional/davinci.nix
    ./common/optional/desktop/hyprland
  ];

  services.yubikey-touch-detector.enable = true;
  services.yubikey-touch-detector.notificationSound = true;
}
