{...}: {
  imports = [
    ./common/core

    ./common/optional/k8s.nix
    ./common/optional/sops.nix
    ./common/optional/discord.nix
    ./common/optional/brower
    ./common/optional/desktop/hyprland
    ./common/optional/xdg.nix # file associations
    ./common/optional/thunderbird.nix
  ];

  # services.yubikey-touch-detector.enable = true;
  # services.yubikey-touch-detector.notificationSound = true;

  programs.git = {
    userEmail = "choffmann@progeek.de";
    userName = "Cedrik Hoffmann";
  };

  programs.hyprpanel = {
    layout = {
      "bar.layouts" = {
        "0" = {
          left = ["dashboard" "workspaces" "windowtitle"];
          middle = ["media"];
          right = ["ram" "cpu" "battery" "network" "volume" "systray" "clock" "notifications"];
        };
        "1" = {
          left = ["dashboard" "workspaces" "windowtitle"];
          middle = ["media"];
          right = ["ram" "cpu" "storage" "network" "volume" "systray" "clock" "notifications"];
        };
      };
    };
  };
}
