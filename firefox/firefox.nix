{ config, pkgs, ... }:
{

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  # https://cmacr.ae/post/2020-05-09-managing-firefox-on-macos-with-nix/
  programs.firefox = {
    enable = true;
    profiles =
      let defaultSettings = {
        "general.smoothScroll" = true;
        "browser.urlbar.placeholderName" = "DuckDuckGo";
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
          "browser.startup.homepage" = "https://reddit.com";
        };
        userChrome = builtins.readFile ./userChrome.css;
      };

      work = {
        id = 1;
        settings = defaultSettings;
      };
    };

    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      bitwarden
      vim-vixen
    ];
  };
}
