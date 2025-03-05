{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.hyprpanel.homeManagerModules.hyprpanel];

  home.packages = with pkgs; [
    hyprpanel
  ];

  programs.hyprpanel = {
    enable = true;
    hyprland.enable = true;
    overwrite.enable = true;

    theme = "catppuccin_mocha";

    layout = {
      "bar.layouts" = {
        "1" = {
          left = ["dashboard" "workspaces" "windowtitle"];
          middle = ["media"];
          right = ["ram" "cpu" "storage" "network" "volume" "systray" "clock" "notifications"];
        };
        "0" = {
          left = ["dashboard" "workspaces"];
          middle = ["media"];
          right = ["volume" "clock" "notifications"];
        };
      };
    };

    settings = {
      menus.dashboard.powermenu.avatar.image = "/home/choffmann/Bilder/profilbilder/73289312.jpeg";
      bar.launcher.autoDetectIcon = true;
      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = true;
      theme.bar.transparent = true;
    };
  };
}
