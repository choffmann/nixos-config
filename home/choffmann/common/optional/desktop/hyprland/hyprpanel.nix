{pkgs, ...}: {
  home.packages = with pkgs; [
    adwaita-icon-theme
    nerd-fonts.jetbrains-mono
  ];

  programs.hyprpanel = {
    enable = true;
    settings = {
      menus.dashboard.powermenu.avatar.image = "/home/choffmann/Bilder/profilbilder/73289312.jpeg";
      bar.launcher.autoDetectIcon = true;
      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = true;
      theme.name = "catppuccin_mocha";
      theme.bar.transparent = true;
    };
  };
}
