_: {
  programs.chromium = {
    enable = true;
    extensions = [
      # bitwarden
      "nngceckbapebfimnlniiiahkandclblb"

      # react dev tools
      "fmkadmapgofadopljbjfkapdkoienihi"
    ];

    commandLineArgs = [
      "--ignore-gpu-blocklist"
      "--no-default-browser-check"
      "--enable-zero-copy"
    ];
  };
  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "chromium.desktop" ];
    "text/xml" = [ "chromium.desktop" ];
    "x-scheme-handler/http" = [ "chromium.desktop" ];
    "x-scheme-handler/https" = [ "chromium.desktop" ];
  };
}
