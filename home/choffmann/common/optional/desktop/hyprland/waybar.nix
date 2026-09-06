{
  pkgs,
  lib,
  config,
  ...
}:
let
  colors = config.lib.stylix.colors.withHashtag;
  c = config.lib.stylix.colors; # for rgba components
  font = config.stylix.fonts.monospace.name;
  rgba =
    color: alpha: "rgba(${c."${color}-rgb-r"}, ${c."${color}-rgb-g"}, ${c."${color}-rgb-b"}, ${alpha})";
in
{
  home.packages = [
    pkgs.socat
    pkgs.cava
  ];

  # Home-manager's default WantedBy mixes in tray.target and graphical-session.target,
  # the latter of which niri's niri.service also binds to; keep waybar Hyprland-only.
  systemd.user.services.waybar.Install.WantedBy = lib.mkForce [ "hyprland-session.target" ];

  xdg.configFile."cava/config-waybar".text = ''
    [general]
    bars = 8
    framerate = 30
    sensitivity = 100

    [input]
    method = pipewire
    source = auto

    [output]
    method = raw
    raw_target = /dev/stdout
    data_format = ascii
    ascii_max_range = 7

    [smoothing]
    noise_reduction = 77
  '';

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 22;
        spacing = 0;
        output = [
          "DP-1"
          "eDP-1"
          "HDMI-A-1"
        ];

        modules-left = [
          "custom/prompt"
          "custom/separator"
          "group/workspaces"
          "hyprland/submap"
          "custom/submap-hint"
        ];
        modules-center = [
          "custom/cava"
          "custom/media"
        ];
        modules-right = [
          "custom/ktt"
          "cpu"
          "memory"
          "disk"
          "network"
          "wireplumber"
          "battery"
          "clock"
          "tray"
        ];

        "group/workspaces" = {
          orientation = "horizontal";
          modules = [
            "hyprland/workspaces"
            "hyprland/window"
          ];
        };

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
          sort-by-number = true;
        };

        "hyprland/submap" = {
          format = "{}";
          tooltip = false;
        };

        "custom/submap-hint" = {
          exec = ''
            socat -u "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - | while read -r line; do
              case "$line" in
                "submap>>resize") echo '{"text": "hjkl resize | SHIFT bigger | q quit"}' ;;
                "submap>>move") echo '{"text": "hjkl move | SHIFT bigger | q quit"}' ;;
                "submap>>power") echo '{"text": "(s)hutdown (r)eboot (p)suspend (l)ock (e)xit (q)uit"}' ;;
                "submap>>") echo '{"text": ""}' ;;
              esac
            done
          '';
          return-type = "json";
          restart-interval = 0;
        };

        "hyprland/window" = {
          format = "{title}";
          format-empty = "";
          max-length = 60;
          separate-outputs = true;
        };

        "custom/prompt" = {
          format = "λ";
          tooltip = false;
        };

        "custom/separator" = {
          format = "❯";
          tooltip = false;
        };

        "custom/media" = {
          exec = ''
            playerctl metadata --format '{{artist}} - {{title}}' --follow 2>/dev/null || echo ""
          '';
          max-length = 40;
          tooltip = false;
          on-click = "playerctl play-pause";
          on-scroll-up = "playerctl next";
          on-scroll-down = "playerctl previous";
        };

        "custom/cava" = {
          exec = ''
            cava -p ~/.config/cava/config-waybar | sed -u 's/;//g;s/0/▁/g;s/1/▂/g;s/2/▃/g;s/3/▄/g;s/4/▅/g;s/5/▆/g;s/6/▇/g;s/7/█/g'
          '';
          tooltip = false;
        };

        clock = {
          format = "[{:%H:%M}]";
          format-alt = "[{:%Y-%m-%d %H:%M}]";
          interval = 60;
          tooltip-format = "<tt>{calendar}</tt>";
        };

        cpu = {
          format = "[cpu {usage}%]";
          interval = 2;
          states = {
            warning = 70;
            critical = 90;
          };
        };

        memory = {
          format = "[mem {percentage}%]";
          interval = 2;
          states = {
            warning = 70;
            critical = 90;
          };
        };

        disk = {
          format = "[disk {percentage_used}%]";
          path = "/";
          interval = 30;
          states = {
            warning = 75;
            critical = 90;
          };
        };

        network = {
          format-wifi = "[net {ipaddr} {signalStrength}%]";
          format-ethernet = "[net {ipaddr}]";
          format-disconnected = "[net --]";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}\nGateway: {gwaddr}";
        };

        wireplumber = {
          format = "[vol {volume}%]";
          format-muted = "[vol --]";
          on-click = "${lib.getExe pkgs.pavucontrol}";
        };

        battery = {
          format = "[bat {capacity}%]";
          format-charging = "[bat+ {capacity}%]";
          format-plugged = "[bat= {capacity}%]";
          states = {
            warning = 30;
            critical = 15;
          };
        };

        tray = {
          spacing = 8;
        };
      };

      secondaryBar = {
        layer = "top";
        position = "top";
        height = 22;
        spacing = 0;
        output = [ "DP-2" ];

        modules-left = [
          "custom/prompt"
          "custom/separator"
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [ ];
        modules-right = [
          "custom/updates"
          "custom/uptime"
          "custom/date"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
          sort-by-number = true;
        };

        "hyprland/window" = {
          format = "{title}";
          format-empty = "";
          max-length = 30;
          separate-outputs = true;
        };

        "custom/prompt" = {
          format = "λ";
          tooltip = false;
        };

        "custom/separator" = {
          format = "❯";
          tooltip = false;
        };

        "custom/uptime" = {
          exec = ''
            awk '{d=int($1/86400);h=int($1%86400/3600);m=int($1%3600/60);if(d>0)printf "[up %dd%dh]",d,h;else if(h>0)printf "[up %dh%dm]",h,m;else printf "[up %dm]",m}' /proc/uptime
          '';
          interval = 60;
          tooltip = false;
        };

        "custom/updates" = {
          exec = ''
            flake_lock="$HOME/nixos-config/flake.lock"
            if [ -f "$flake_lock" ]; then
              days_old=$(( ($(date +%s) - $(stat -c %Y "$flake_lock")) / 86400 ))
              if [ "$days_old" -gt 7 ]; then
                echo "{\"text\": \"[nix ''${days_old}d]\", \"class\": \"warning\"}"
              else
                echo "{\"text\": \"[nix ''${days_old}d]\", \"class\": \"ok\"}"
              fi
            else
              echo "{\"text\": \"[nix --]\"}"
            fi
          '';
          return-type = "json";
          interval = 3600;
          tooltip-format = "Days since last flake update";
          on-click = "cd ~/nixos-config && nix flake update";
        };

        "custom/date" = {
          exec = "date +'[%a %d.%m] [%H:%M]'";
          interval = 60;
          tooltip = false;
        };
      };
    };

    style = ''
      * {
        font-family: "${font}", monospace;
        font-size: 14px;
        border: none;
        border-radius: 0;
        min-height: 0;
        background-color: transparent;
      }

      window#waybar {
        background-color: ${rgba "base00" "0.8"};
        color: ${colors.base04};
        padding: 0;
      }

      window#waybar > box {
        padding: 0;
        margin: 0;
      }

      #custom-prompt {
        color: ${colors.base0B};
        padding: 0 0 0 8px;
      }

      #custom-separator {
        color: ${colors.base09};
        padding: 0 6px;
      }

      #workspaces-group {
        padding: 0;
      }

      #workspaces {
        padding: 0;
      }

      #workspaces button {
        padding: 0 4px;
        color: ${colors.base04};
      }

      #workspaces button:hover {
        color: ${colors.base06};
      }

      #workspaces button.active {
        color: ${colors.base05};
      }

      #workspaces button.urgent {
        color: ${colors.base08};
      }

      #window {
        padding: 0 0 0 6px;
        color: ${colors.base06};
      }

      #submap {
        background-color: ${colors.base09};
        color: ${colors.base00};
        padding: 0 6px;
        margin: 0 0 0 8px;
        font-weight: bold;
      }

      #custom-submap-hint {
        color: ${colors.base04};
        padding: 0 6px;
        font-style: italic;
      }

      #custom-media {
        color: ${colors.base06};
        padding: 0 8px;
      }

      #custom-cava {
        color: ${colors.base0B};
        letter-spacing: 2px;
      }

      #custom-uptime {
        color: ${colors.base04};
        padding: 0 4px;
      }

      #custom-updates {
        color: ${colors.base0B};
        padding: 0 4px;
      }

      #custom-updates.warning {
        color: ${colors.base09};
      }

      #custom-date {
        color: ${colors.base06};
        padding: 0 8px 0 4px;
      }

      #custom-ktt {
        padding: 0 4px;
        color: ${colors.base03};
      }

      #custom-ktt.running {
        color: ${colors.base0B};
      }

      #cpu,
      #memory,
      #disk,
      #network,
      #wireplumber,
      #battery,
      #clock {
        padding: 0 4px;
        color: ${colors.base04};
      }

      #clock {
        color: ${colors.base06};
        padding-right: 8px;
      }

      #tray {
        padding: 0 8px 0 4px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #network.disconnected,
      #wireplumber.muted {
        color: ${colors.base03};
      }

      #cpu.warning,
      #memory.warning,
      #disk.warning,
      #battery.warning {
        color: ${colors.base09};
      }

      #cpu.critical,
      #memory.critical,
      #disk.critical,
      #battery.critical {
        color: ${colors.base08};
      }

      #battery.charging {
        color: ${colors.base0B};
      }

      tooltip {
        background-color: ${rgba "base01" "0.9"};
        border: 1px solid ${colors.base02};
      }

      tooltip label {
        color: ${colors.base05};
      }
    '';
  };
}
