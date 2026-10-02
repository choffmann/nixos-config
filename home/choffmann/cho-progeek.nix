{ pkgs, ... }:
let
  hdmiMirror =
    let
      source = "eDP-1";
      target = "HDMI-A-1";
    in
    pkgs.writeShellApplication {
      name = "hdmi-mirror";
      runtimeInputs = with pkgs; [
        niri
        wl-mirror
        jq
        libnotify
        procps
      ];
      # niri cannot mirror outputs itself, so wl-mirror captures the panel into
      # a window that it fullscreens onto the external output.
      text = ''
        if pkill -x wl-mirror; then
          notify-send "HDMI-Mirror" "Spiegelung beendet"
          exit 0
        fi

        if ! niri msg --json outputs | jq -e 'has("${target}")' >/dev/null; then
          notify-send -u critical "HDMI-Mirror" "${target} ist nicht angeschlossen"
          exit 1
        fi

        niri msg output ${target} on
        exec wl-mirror --fullscreen-output ${target} ${source}
      '';
    };
in
{
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

  # niri only allows a single top-level `binds` node, so this merges into
  # the shared one from config.kdl.nix rather than appending a second one.
  desktop.niri.extraBinds = ''
    Mod+Shift+M hotkey-overlay-title="Mirror Screen to HDMI" { spawn "${hdmiMirror}/bin/hdmi-mirror"; }
  '';

  # Monitors live in DMS' dms/outputs.kdl, not here: niri resolves outputs by
  # first match, so a block here would shadow whatever DMS writes. Until DMS
  # has saved them once, this host comes up on niri's autodetected layout.
  # Previous placement: eDP-1 at x=-1920, DP-1 at x=0, HDMI-A-1 at x=3440 y=180.
}
