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

  # niri overrides
  #
  # Outputs are declarative and hotplug-driven: a block for a disconnected
  # output is simply inert, so docked and undocked are the same config.
  # The laptop panel sits left of the desks' primary screen, which keeps
  # the undocked-only case at x=0 too.
  desktop.niri.extraConfig = ''
    output "eDP-1" {
        mode "1920x1080@60.000"
        scale 1.0
        position x=-1920 y=0
    }

    output "DP-1" {
        mode "3440x1440@59.973"
        scale 1.0
        position x=0 y=0
    }

    output "HDMI-A-1" {
        mode "1920x1080@60.000"
        scale 1.0
        position x=3440 y=180
    }
  '';
}
