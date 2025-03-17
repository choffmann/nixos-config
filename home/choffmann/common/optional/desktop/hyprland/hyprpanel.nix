{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.hyprpanel.homeManagerModules.hyprpanel];

  home.packages = with pkgs; [
    hyprpanel
    adwaita-icon-theme
  ];

  programs.hyprpanel = {
    enable = true;
    hyprland.enable = true;
    overwrite.enable = true;

    theme = "catppuccin_mocha";

    settings = {
      menus.dashboard.powermenu.avatar.image = "/home/choffmann/Bilder/profilbilder/73289312.jpeg";
      bar.launcher.autoDetectIcon = true;
      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = true;
      theme.bar.transparent = true;
    };
  };
}
