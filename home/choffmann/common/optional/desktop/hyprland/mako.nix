{lib, ...}: {
  services.mako = {
    enable = true;

    settings = {
      font = lib.mkForce "JetBrainsMono Nerd Font 11";
      background-color = lib.mkForce "#11111bcc";
      text-color = lib.mkForce "#cdd6f4";
      border-color = lib.mkForce "#a6e3a1";
      border-radius = lib.mkForce 0;
      border-size = lib.mkForce 1;
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
        text-color = lib.mkForce "#6c7086";
        border-color = lib.mkForce "#313244";
        default-timeout = lib.mkForce 3000;
      };

      "urgency=critical" = {
        text-color = lib.mkForce "#f38ba8";
        border-color = lib.mkForce "#f38ba8";
        default-timeout = lib.mkForce 0;
      };
    };
  };
}
