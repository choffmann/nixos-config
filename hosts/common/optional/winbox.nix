{pkgs, ...}: {
  hardware.graphics.enable32Bit = true;

  programs.winbox = {
    enable = true;
    openFirewall = true;
    package = pkgs.winbox.override {
      wine = pkgs.wine.override {wineBuild = "wine64";};
    };
  };

  environment.sessionVariables.WINEARCH = "win64";
  environment.systemPackages = with pkgs; [winetricks];
}
