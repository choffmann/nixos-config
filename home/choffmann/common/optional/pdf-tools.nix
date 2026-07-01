{ pkgs, ... }: {
  home.packages = with pkgs; [
    pdfarranger
    xournalpp
  ];
}
