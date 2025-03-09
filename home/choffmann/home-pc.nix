{pkgs, ...}: let
  virtLookingGlassHandler = let
    vmName = "win10";
  in
    pkgs.writeShellApplication {
      name = "virt-hyprland-handler";
      text = ''
        if [ "$(virsh --connect qemu:///system domstate ${vmName})" != "running" ]; then
          virsh --connect qemu:///system start ${vmName}
        fi

        looking-glass-client -F
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
