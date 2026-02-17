{...}: {
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
          }
        ];
      }
      {
        profile.name = "docked-dual";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "DP-*";
            status = "enable";
            position = "1920,0";
          }
          {
            criteria = "HDMI-A-1";
            status = "enable";
            position = "0,0";
            mode = "1920x1080";
          }
        ];
      }
      {
        profile.name = "docked-single";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "DP-*";
            status = "enable";
          }
        ];
      }
    ];
  };
}
