{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.desktop.niri;
  colors = config.lib.stylix.colors.withHashtag;
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

    extraBinds = lib.mkOption {
      type = lib.types.lines;
      default = "";
      # niri only allows a single top-level `binds` node, so host-specific
      # binds must be merged into the shared one instead of appended via extraConfig.
      description = "Host-specific KDL bind lines merged into the shared binds block";
    };
  };

  config = {
    home.packages = with pkgs; [
      networkmanagerapplet
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
      borderActiveColor = colors.base0D;
      borderInactiveColor = colors.base02;
      inherit (cfg) extraConfig extraBinds;
    };
  };
}
