{pkgs, ...}:
{
  programs.chromium = {
    enable = true;
    extensions = [
      # bitwarden
      "nngceckbapebfimnlniiiahkandclblb"
    ];

    commandLineArgs = [
      "--ignore-gpu-blocklist"
      "--enable-zero-copy"
    ];
  };
}

