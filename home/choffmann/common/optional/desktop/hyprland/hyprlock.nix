{
  lib,
  config,
  ...
}: let
  c = config.lib.stylix.colors;
  font = config.stylix.fonts.monospace.name;
  rgba = color: alpha: "rgba(${c."${color}-rgb-r"}, ${c."${color}-rgb-g"}, ${c."${color}-rgb-b"}, ${alpha})";
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 5;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = lib.mkForce [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
          color = "${rgba "base00" "1.0"}";
        }
      ];

      input-field = lib.mkForce [
        {
          font_family = "${font}";
          monitor = "";
          size = "300, 40";
          outline_thickness = 1;
          dots_size = 0.25;
          dots_spacing = 0.3;
          dots_center = true;
          outer_color = "${rgba "base0B" "1.0"}";
          inner_color = "${rgba "base01" "0.8"}";
          font_color = "${rgba "base05" "1.0"}";
          fade_on_empty = false;
          placeholder_text = "<i><span foreground=\"##${c.base04}\">❯ password...</span></i>";
          hide_input = false;
          rounding = 0;
          check_color = "${rgba "base09" "1.0"}";
          fail_color = "${rgba "base08" "1.0"}";
          fail_text = "$FAIL";
          fail_transition = 300;
          capslock_color = "${rgba "base09" "1.0"}";
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];

      label = lib.mkForce [
        # Time
        {
          monitor = "";
          text = "cmd[update:1000] echo \"[$(date +\"%H:%M\")]\"";
          color = "${rgba "base05" "1.0"}";
          font_size = 80;
          font_family = "${font}";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
        # Date
        {
          monitor = "";
          text = "cmd[update:1000] echo \"[$(date +\"%a %d.%m.%Y\")]\"";
          color = "${rgba "base04" "1.0"}";
          font_size = 20;
          font_family = "${font}";
          position = "0, 120";
          halign = "center";
          valign = "center";
        }
        # User
        {
          monitor = "";
          text = "λ $USER";
          color = "${rgba "base0B" "1.0"}";
          font_size = 16;
          font_family = "${font}";
          position = "0, 50";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
