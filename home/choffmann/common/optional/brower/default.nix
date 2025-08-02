{pkgs, ...}: {
  home.packages = with pkgs; [
    zotero
  ];

  imports = [
    ./chromium.nix
    # ./firefox.nix
    ./zen.nix
  ];
}
