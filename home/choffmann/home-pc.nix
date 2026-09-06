{ pkgs, ... }:
let
  virtLookingGlassHandler =
    let
      vmName = "win11";
    in
    pkgs.writeShellApplication {
      name = "virt-looking-glass";
      text = ''
        if [ "$(virsh --connect qemu:///system domstate ${vmName})" != "running" ]; then
          virsh --connect qemu:///system start ${vmName}
        fi

        looking-glass-client -f /dev/kvmfr0 -F
      '';
    };

  sinkSpeaker = "alsa_output.usb-Generic_USB_Audio-00.HiFi__Speaker__sink";
  sinkHeadset = "alsa_output.usb-RODE_Microphones_RODE_NT-USB-00.analog-stereo";

  audioToggle = pkgs.writeShellApplication {
    name = "audio-toggle";
    runtimeInputs = with pkgs; [
      wireplumber
      libnotify
      gnugrep
    ];
    text = ''
      get_sink_id() {
        wpctl inspect @DEFAULT_AUDIO_SINK@ | grep -oP 'id \K\d+'
      }

      get_id_by_name() {
        pw-cli list-objects Node 2>/dev/null \
          | grep -B20 "node.name = \"$1\"" \
          | grep "^[[:space:]]*id " \
          | tail -1 \
          | grep -oP 'id \K\d+'
      }

      speaker_id=$(get_id_by_name "${sinkSpeaker}")
      headset_id=$(get_id_by_name "${sinkHeadset}")
      current_id=$(get_sink_id)

      if [ "$current_id" = "$speaker_id" ]; then
        wpctl set-default "$headset_id"
        notify-send -t 2000 "Audio" "RODE NT-USB"
      else
        wpctl set-default "$speaker_id"
        notify-send -t 2000 "Audio" "USB Speakers"
      fi
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
    ./common/optional/matrix.nix
    ./common/optional/synology-drive.nix
  ];

  # services.yubikey-touch-detector.enable = true;
  # services.yubikey-touch-detector.notificationSound = true;

  # niri overrides
  #
  # Monitors live in DMS' dms/outputs.kdl, not here: niri resolves outputs by
  # first match, so a block here would shadow whatever DMS writes.
  desktop.niri.extraConfig = ''
    spawn-at-startup "${pkgs.synology-drive-client}/bin/synology-drive"

    window-rule {
        match app-id=r#"^looking-glass-client$"#
        open-on-output "DP-1"
    }
  '';

  # niri only allows a single top-level `binds` node, so this merges into
  # the shared one from config.kdl.nix rather than appending a second one.
  desktop.niri.extraBinds = ''
    Mod+Shift+W { spawn "${virtLookingGlassHandler}/bin/virt-looking-glass"; }
    Mod+Shift+A { spawn "${audioToggle}/bin/audio-toggle"; }
  '';

  desktop.niri.extraInput = ''
    tablet {
        map-to-output "DP-1"
    }
  '';
}
