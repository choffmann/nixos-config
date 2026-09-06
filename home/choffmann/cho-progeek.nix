_: {
  imports = [
    ./common/core

    ./common/optional/k8s.nix
    ./common/optional/iac.nix
    ./common/optional/sops.nix
    ./common/optional/discord.nix
    ./common/optional/browser
    ./common/optional/desktop/niri
    ./common/optional/mime-associations.nix
    ./common/optional/thunderbird.nix
    ./common/optional/pdf-tools.nix
    ./common/optional/tpp.nix
    ./common/optional/ktt-rofi.nix
  ];

  # services.yubikey-touch-detector.enable = true;
  # services.yubikey-touch-detector.notificationSound = true;

  programs.git = {
    userEmail = "choffmann@progeek.de";
    userName = "Cedrik Hoffmann";
  };

  # Monitors live in DMS' dms/outputs.kdl, not here: niri resolves outputs by
  # first match, so a block here would shadow whatever DMS writes. Until DMS
  # has saved them once, this host comes up on niri's autodetected layout.
  # Previous placement: eDP-1 at x=-1920, DP-1 at x=0, HDMI-A-1 at x=3440 y=180.
}
