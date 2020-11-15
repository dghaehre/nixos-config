{ config, pkgs, ... }:

let colors = import ../colors.nix; in
{

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  # https://cmacr.ae/post/2020-05-09-managing-firefox-on-macos-with-nix/
  # TODO: see a difference between work and personal..
  programs.firefox = {
    enable = true;
    profiles =
      let defaultSettings = {
        "general.smoothScroll" = true;
        "browser.urlbar.placeholderName" = "DuckDuckGo";
        "browser.search.defaultenginename" = "DuckDuckGo";
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" = "DuckDuckGo";
        "app.update.auto" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.startup.homepage" = "https://duckduckgo.com";
        "devtools.theme" = "dark";
        "browser.in-content.dark-mode" = true;
        "browser.ctrlTab.recentlyUsedOrder" = false;
        "signon.rememberSignons" = false;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.trackingprotection.socialtracking.annotate.enabled" = true;
        "services.sync.declinedEngines" = "addons,passwords,prefs";
        "services.sync.engine.addons" = false;
        "services.sync.engineStatusChanged.addons" = true;
        "services.sync.engine.passwords" = false;
        "services.sync.engine.prefs" = false;
      };
      in {
      dghaehre = {
	id = 0;
        settings = defaultSettings // {
          "browser.startup.homepage" = "about:home";
        };
        userChrome = (builtins.concatStringsSep "" [''
:root {
  --uc-urlbar-bg-color: ${colors.primary.background};
  --uc-show-new-tab-button: none;
  --uc-show-tab-separators: none;
  --uc-tab-separators-color: none;
  --uc-tab-separators-width: none;
  --uc-urlbar-selected-bg-color: ${colors.normal.cyan};
}
          ''
          (builtins.readFile ./userChrome.css)]
        );
      };

      work = {
        id = 1;
        settings = defaultSettings // {
          "browser.startup.homepage" = "about:blank";
        };
        userChrome = (builtins.concatStringsSep "" [''
:root {
  --uc-urlbar-bg-color: ${colors.primary.background};
  --uc-show-new-tab-button: none;
  --uc-show-tab-separators: none;
  --uc-tab-separators-color: none;
  --uc-tab-separators-width: none;
  --uc-urlbar-selected-bg-color: ${colors.normal.red};
}
          ''
          (builtins.readFile ./userChrome.css)]
        );
      };

      omni = {
        id = 2;
        settings = defaultSettings // {
          "browser.startup.homepage" = "about:blank";
        };
        userChrome = (builtins.concatStringsSep "" [''
:root {
  --uc-urlbar-bg-color: ${colors.primary.background};
  --uc-show-new-tab-button: none;
  --uc-show-tab-separators: none;
  --uc-tab-separators-color: none;
  --uc-tab-separators-width: none;
  --uc-urlbar-selected-bg-color: ${colors.bright.blue};
}
          ''
          (builtins.readFile ./userChrome.css)]
        );
      };
    };

    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      bitwarden
      vim-vixen
    ];
  };
}
