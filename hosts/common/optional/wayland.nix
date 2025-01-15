{pkgs, ...}: {
  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
  };

  environment.systemPackages = with pkgs; [
    grim # screen capture component, required by flameshot

    grimblast
    satty
  ];
}
