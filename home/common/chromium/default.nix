{pkgs, ...}:
{
  programs.chromium = {
    enable = true;
    extensions = [
      # bitwarden
      "nngceckbapebfimnlniiiahkandclblb"
    ];
  };
}

