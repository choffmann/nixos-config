{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.desktop.niri;
in
{
  imports = [
    ../wayland-env.nix
    ./dms.nix
  ];

  options.desktop.niri = {
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Host-specific KDL appended to the shared niri config";
    };

    startupCommands = lib.mkOption {
      type = lib.types.listOf (lib.types.listOf lib.types.str);
      default = [ ];
      description = "Each inner list becomes one spawn-at-startup argv";
    };
  };

  config = {
    home.packages = with pkgs; [
      networkmanagerapplet
      polkit_gnome
      nautilus

      brightnessctl
      imagemagick
      libnotify
      pavucontrol
      playerctl
      slurp
      grim
      satty
      swappy
      wl-clipboard
      wf-recorder
      wlsunset
    ];

    xdg.configFile."niri/config.kdl".text = import ./config.kdl.nix {
      inherit lib;
      terminal = "ghostty";
      inherit (cfg) startupCommands extraConfig;
    };
  };
}
