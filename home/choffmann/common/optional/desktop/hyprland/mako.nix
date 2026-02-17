{
  lib,
  config,
  ...
}: let
  colors = config.lib.stylix.colors.withHashtag;
  c = config.lib.stylix.colors;
  font = config.stylix.fonts.monospace.name;
  rgba = color: alpha: "rgba(${c."${color}-rgb-r"}, ${c."${color}-rgb-g"}, ${c."${color}-rgb-b"}, ${alpha})";
in {
  services.mako = {
    enable = true;

    settings = {
      font = lib.mkForce "${font} 11";
      border-color = lib.mkForce colors.base0B;
      border-radius = lib.mkForce 0;
      padding = "8";
      margin = "8";
      width = 350;
      height = 150;
      max-visible = 5;
      default-timeout = 5000;
      group-by = "app-name";
      sort = "-time";
      layer = "overlay";
      anchor = "top-right";
      format = "<b>[%a]</b> %s\\n%b";
      icons = true;
      max-icon-size = 48;

      "urgency=low" = {
        text-color = lib.mkForce colors.base04;
        border-color = lib.mkForce colors.base02;
        default-timeout = lib.mkForce 3000;
      };

      "urgency=critical" = {
        text-color = lib.mkForce colors.base08;
        border-color = lib.mkForce colors.base08;
        default-timeout = lib.mkForce 0;
      };
    };
  };
}
