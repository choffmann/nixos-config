{
  pkgs,
  config,
  inputs,
  ...
}:
let
  homeDir = config.home.homeDirectory;

  extension = shortId: uuid: {
    name = uuid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };
in
{
  policies = {
    AppAutoUpdate = true;
    StartPage = "previous-session";
    BackgroundAppUpdate = false;
    DefaultDownloadDirectory = "${homeDir}/downloads";
    DisableBuiltinPDFViewer = false;
    DisableFirefoxStudies = true;
    DisableTelemetry = true;
    DisableFirefoxAccounts = false;
    DisablePocket = true;
    DontCheckDefaultBrowser = true;
    OfferToSaveLogins = false;
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
      EmailTracking = true;
    };
    ExtensionUpdate = true;
    ExtensionSettings = builtins.listToAttrs [
      (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
      (extension "react-devtools" "@react-devtools")
    ];
  };

  extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
    bitwarden
    react-devtools
    surfingkeys
    ublock-origin
    user-agent-string-switcher
    catppuccin-web-file-icons
    multi-account-containers
    zotero-connector
  ];

  bookmarks = {
    force = true;
    settings = [
      {
        name = "NixOS home-manager";
        tags = [
          "search"
          "nix"
          "home-manager"
        ];
        url = "https://nix-community.github.io/home-manager/options.xhtml";
      }
      {
        name = "NixOS Wiki";
        tags = [
          "wiki"
          "nix"
        ];
        url = "https://wiki.nixos.org/";
      }
      {
        toolbar = false;
        bookmarks = [
          {
            name = "GitHub";
            tags = [ "dev" ];
            keyword = "github";
            url = "https://github.com";
          }
          {
            name = "YouTube";
            url = "https://youtube.com";
          }
          {
            name = "Excalidraw";
            url = "https://excalidraw.com";
          }
          {
            name = "NixOS Search";
            tags = [
              "search"
              "nix"
            ];
            url = "https://search.nixos.org/packages";
          }
        ];
      }
    ];
  };

  settings = {
    "signon.rememberSignons" = false;
    "browser.compactmode.show" = true;
    "browser.uidensity" = 1;
    "browser.aboutConfig.showWarning" = false;
    "browser.download.dir" = "${homeDir}/downloads";
    "browser.tabs.firefox-view" = true;
    "extensions.pocket.enabled" = false;
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "browser.newtabpage.activity-stream.improvesearch.handoffToAwesomebar" = false;
    "zen.urlbar.behavior" = "float";
  };

  search = {
    force = true;
    default = "ddg";
    engines = {
      nix-packages = {
        name = "Nix Packages";
        urls = [
          {
            template = "https://search.nixos.org/packages";
            params = [
              {
                name = "type";
                value = "packages";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@np" ];
      };

      github = {
        name = "GitHub";
        urls = [
          {
            template = "https://github.com/search";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = "https://github.githubassets.com/favicons/favicon.svg";
        definedAliases = [ "@gh" ];
      };

      nixos-wiki = {
        name = "NixOS Wiki";
        urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
        iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
        definedAliases = [ "@nw" ];
      };

      bing.metaData.hidden = true;
      google.metaData.alias = "@g";
    };
  };

  containers = {
    dev = {
      color = "blue";
      icon = "fingerprint";
      id = 1;
    };
    work = {
      color = "orange";
      icon = "briefcase";
      id = 2;
    };
  };
}
