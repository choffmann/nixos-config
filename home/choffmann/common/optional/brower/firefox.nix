{
  pkgs,
  config,
  inputs,
  ...
}: let
  homeDir = config.home.homeDirectory;
in {
  home.packages = with pkgs; [
    zotero
  ];

  programs.firefox = {
    enable = true;
    languagePacks = ["de" "en"];
    policies = {
      AppAutoUpdate = true;
      StartPage = "previous-session";
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
    profiles.choffmann = {
      id = 0;
      name = "Cedrik";
      isDefault = true;

      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        react-devtools
        surfingkeys
        ublock-origin
        user-agent-string-switcher
        catppuccin-web-file-icons
        multi-account-containers
        zotero-connector
        sidebery
      ];

      bookmarks = {
        force = true;
        settings = [
          {
            name = "NixOS home-manager";
            tags = ["search" "nix" "home-manager"];
            url = "https://nix-community.github.io/home-manager/options.xhtml";
          }
          {
            name = "NixOS Wiki";
            tags = ["wiki" "nix"];
            url = "https://wiki.nixos.org/";
          }
          {
            toolbar = false;
            bookmarks = [
              {
                name = "GitHub";
                tags = ["dev"];
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
                tags = ["search" "nix"];
                url = "https://search.nixos.org/packages";
              }
            ];
          }
        ];
      };

      settings = {
        "signon.rememberSignons" = false; # Disable built-in password manager
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1; # enable compact mode
        "browser.aboutConfig.showWarning" = false;
        "browser.download.dir" = "${homeDir}/downloads";

        "browser.tabs.firefox-view" = true; # Sync tabs across devices
        "extensions.pocket.enabled" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
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
            definedAliases = ["@np"];
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
            definedAliases = ["@gh"];
          };

          nixos-wiki = {
            name = "NixOS Wiki";
            urls = [{template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";}];
            iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
            definedAliases = ["@nw"];
          };

          bing.metaData.hidden = true;
          google.metaData.alias = "@g";
        };
      };

      containersForce = true;
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

      userChrome = ''
                @-moz-document url(chrome://browser/content/browser.xhtml) {
        	/* tabs on bottom of window */
        	/* requires that you set
        	 * toolkit.legacyUserProfileCustomizations.stylesheets = true
        	 * in about:config
        	 * figure out current firefox's profile folder in about:support
        	 */
        	#main-window body { flex-direction: column-reverse !important; }
        	#navigator-toolbox { flex-direction: column-reverse !important; }
        	#urlbar {
        		top: unset !important;
        		/* bottom: calc(var(--urlbar-container-height) + 2 * var(--urlbar-padding-block)) !important; */
                        bottom: 5px !important;
        		box-shadow: none !important;
        		display: flex !important;
        		flex-direction: column !important;
        	}
                #urlbar > * {
                        flex: none;
                }
        	#urlbar .urlbar-input-container {
        		order: 2;
        	}
        	#urlbar > .urlbarView {
        		order: 1;
        		border-bottom: 1px solid #666;
        	}
        	#urlbar-results {
        		display: flex;
        		flex-direction: column-reverse;
        	}
        	.search-one-offs { display: none !important; }
        	.tab-background { border-top: none !important; }
        	#navigator-toolbox::after { border: none; }
        	#TabsToolbar .tabbrowser-arrowscrollbox,
        	#tabbrowser-tabs, .tab-stack { min-height: 28px !important; }
        	.tabbrowser-tab { font-size: 80%; }
        	.tab-content { padding: 0 5px; }
        	.tab-close-button .toolbarbutton-icon { width: 12px !important; height: 12px !important; }
        	toolbox[inFullscreen=true] { display: none; }
        	/*
        	 * the following makes it so that the on-click panels in the nav-bar
        	 * extend upwards, not downwards. some of them are in the #mainPopupSet
        	 * (hamburger + unified extensions), and the rest are in
        	 * #navigator-toolbox. They all end up with an incorrectly-measured
        	 * max-height (based on the distance to the _bottom_ of the screen), so
        	 * we correct that. The ones in #navigator-toolbox then adjust their
        	 * positioning automatically, so we can just set max-height. The ones
        	 * in #mainPopupSet do _not_, and so we need to give them a
        	 * negative margin-top to offset them *and* a fixed height so their
        	 * bottoms align with the nav-bar. We also calc to ensure they don't
        	 * end up overlapping with the nav-bar itself. The last bit around
        	 * cui-widget-panelview is needed because "new"-style panels (those
        	 * using "unified" panels) don't get flex by default, which results in
        	 * them being the wrong height.
        	 *
        	 * Oh, yeah, and the popup-notification-panel (like biometrics prompts)
        	 * of course follows different rules again, and needs its own special
        	 * rule.
        	 */
        	#mainPopupSet panel.panel-no-padding { margin-top: calc(-50vh + 40px) !important; }
        	#mainPopupSet .panel-viewstack, #mainPopupSet popupnotification { max-height: 50vh !important; height: 50vh; }
        	#mainPopupSet panel.panel-no-padding.popup-notification-panel { margin-top: calc(-50vh - 35px) !important; }
        	#navigator-toolbox .panel-viewstack { max-height: 75vh !important; }
        	panelview.cui-widget-panelview { flex: 1; }
        	panelview.cui-widget-panelview > vbox { flex: 1; min-height: 50vh; }

                /* Disabel Toolbar */
                #TabsToolbar { visibility: collapse; }
        }
      '';
    };
  };
}
