{...}: {
  programs.firefox = {
    enable = true;
    languagePacks = ["de"];
    policies = {
      DisableFirefoxStudies = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = false;
    };
  };
}
