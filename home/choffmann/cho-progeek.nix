{...}: {
  imports = [
    ./common/core

    ./common/optional/k8s.nix
    ./common/optional/sops.nix
    ./common/optional/discord.nix
    ./common/optional/browser
    ./common/optional/desktop/hyprland
    ./common/optional/mime-associations.nix
    ./common/optional/thunderbird.nix
    ./common/optional/pdf-tools.nix
    ./common/optional/tpp.nix
  ];

  # services.yubikey-touch-detector.enable = true;
  # services.yubikey-touch-detector.notificationSound = true;

  programs.git = {
    userEmail = "choffmann@progeek.de";
    userName = "Cedrik Hoffmann";
  };
}
