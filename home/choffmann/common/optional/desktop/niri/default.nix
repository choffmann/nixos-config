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
    ../rofi
    ./dms.nix
    ./dsearch.nix
    ./dcal.nix
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

    extraInput = lib.mkOption {
      type = lib.types.lines;
      default = "";
      # Same single-node restriction as `binds` applies to `input`.
      description = "Host-specific KDL merged into the shared input block";
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
      # niri's wayland-session enables security.polkit but ships no auth agent.
      polkitAgent = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      inherit (cfg) extraConfig extraBinds extraInput;
    };
  };
}
