{ pkgs, ... }: {
  environment.sessionVariables = {
    QT_QPA_PLATFORM = "xcb";
  };

  environment.systemPackages = with pkgs; [
    grim # screen capture component, required by flameshot

    grimblast
    satty
  ];
}
