{pkgs, ...}: let
  virtLookingGlassHandler = let
    vmName = "win11";
  in
    pkgs.writeShellApplication {
      name = "virt-hyprland-handler";
      text = ''
        if [ "$(virsh --connect qemu:///system domstate ${vmName})" != "running" ]; then
          virsh --connect qemu:///system start ${vmName}
        fi

        looking-glass-client -f /dev/kvmfr0 -F
      '';
    };
in {
  imports = [
    ./common/core

    ./common/optional/k8s.nix
    ./common/optional/sops.nix
    ./common/optional/discord.nix
    ./common/optional/brower
    ./common/optional/desktop/hyprland
    ./common/optional/xdg.nix # file associations
    ./common/optional/thunderbird.nix
    ./common/optional/pdf-tools.nix
    ./common/optional/matrix.nix
    ./common/optional/synology-drive.nix
  ];

  # services.yubikey-touch-detector.enable = true;
  # services.yubikey-touch-detector.notificationSound = true;

  # hyprland overrides
  wayland.windowManager.hyprland.settings = {
    workspace = [
      "special:windows, on-created-empty:${virtLookingGlassHandler}/bin/virt-hyprland-handler"
    ];

    bind = [
      "$mod + SHIFT, W, togglespecialworkspace, windows"
    ];
  };

}
