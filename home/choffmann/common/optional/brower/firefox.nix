{config, ...}: let
  homeDir = config.home.homeDirectory;
in {
  programs.firefox = {
    enable = true;
    languagePacks = ["de"];
    policies = {
      AppAutoUpdate = true;
      BackgroundAppUpdate = false;
      DefaultDownloadDirectory = "${config.home.homeDirectory}/downloads";
      DisableBuiltinPDFViewer = false;
      DisableFirefoxStudies = true;
      DisableTelemetry = true;
      DisableFirefoxAccounts = false; # Enable Firefox Sync
      DisablePocket = true;
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = false; # Managed by vaultwarden
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
        # Exceptions = ["https://example.com"]
      };

      ExtensionUpdate = true;

      ExtensionSettings = let
        extension = shortId: uuid: {
          name = uuid;
          value = {
            install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
            installation_mode = "normal_installed";
          };
        };
      in
        builtins.listToAttrs [
          (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
          (extension "react-devtools" "@react-devtools")
        ];
    };
    profiles.main = {
      id = 0;
      name = "Cedrik";
      isDefault = true;
      settings = {
        "signon.rememberSignons" = false; # Disable built-in password manager
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1; # enable compact mode
        "browser.aboutConfig.showWarning" = false;
        "browser.download.dir" = "${homeDir}/downloads";

        "browser.tabs.firefox-view" = true; # Sync tabs across devices
        "extensions.pocket.enabled" = false;
      };

      userChrome = ''
        /* Hide tab bar in FF Quantum */
        @-moz-document url("chrome://browser/content/browser.xul") {
          #TabsToolbar {
            visibility: collapse !important;
            margin-bottom: 21px !important;
          }

          #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
            visibility: collapse !important;
          }
        }
      '';
    };
  };
}
