{ pkgs, ... }: {
  home.file.".local/share/backgrounds/progeek" = {
    source = ./progeek;
    recursive = true;
  };
}

