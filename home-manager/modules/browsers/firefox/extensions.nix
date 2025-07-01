{
  ublock-origin = {
    id = "uBlock0@raymondhill.net";
    privateAllowed = true;
    settings = {
      userSettings = {
        cloudStorageEnabled = true;
        externalLists = "https://www.i-dont-care-about-cookies.eu/abp/";
        importedLists = [
          "https://www.i-dont-care-about-cookies.eu/abp/"
        ];
      };
      selectedFilterLists = [
        "user-filters"
        "ublock-filters"
        "ublock-badware"
        "ublock-privacy"
        "ublock-unbreak"
        "easylist"
        "easyprivacy"
        "adguard-spyware"
        "adguard-spyware-url"
        "urlhaus-1"
        "plowe-0"
        "fanboy-cookiemonster"
        "fanboy-social"
        "adguard-social"
        "ublock-annoyances"
        "DEU-0"
        "https://www.i-dont-care-about-cookies.eu/abp/"
      ];
      # selectedFilterLists = [
      #   "user-filters"
      #   "ublock-filters"
      #   "ublock-badware"
      #   "ublock-privacy"
      #   "ublock-unbreak"
      #   "ublock-quick-fixes"
      #   "easylist"
      #   "easyprivacy"
      #   "urlhaus-1"
      #   "plowe-0"
      # ];
    };
    permissions = [
      "alarms"
      "dns"
      "menus"
      "privacy"
      "storage"
      "tabs"
      "unlimitedStorage"
      "webNavigation"
      "webRequest"
      "webRequestBlocking"
      "<all_urls>"
      "http://*/*"
      "https://*/*"
      "file://*/*"
      "https://easylist.to/*"
      "https://*.fanboy.co.nz/*"
      "https://filterlists.com/*"
      "https://forums.lanik.us/*"
      "https://github.com/*"
      "https://*.github.io/*"
      "https://github.com/uBlockOrigin/*"
      "https://ublockorigin.github.io/*"
      "https://*.reddit.com/r/uBlockOrigin/*"
    ];
  };
  darkreader = {
    id = "addon@darkreader.org";
    privateAllowed = true;
    permissions = [
      "alarms"
      "contextMenus"
      "storage"
      "tabs"
      "theme"
      "https://*/*"
      "http://*/*"
      "https://api.github.com/"
      "<all_urls>"
    ];
  };
  foxyproxy-standard = {
    id = "foxyproxy@eric.h.jung";
    privateAllowed = true;
    permissions = [
      "contextMenus"
      "downloads"
      "notifications"
      "proxy"
      "storage"
      "tabs"
      "webRequest"
      "webRequestAuthProvider"
      "<all_urls>"
    ];
    settings = {
      data = [
        {
          active = true;
          title = "new york 603";
          type = "socks5";
          hostname = "us-nyc-wg-socks5-603.relays.mullvad.net";
          port = "1080";
          username = "";
          password = "";
          cc = "";
          city = "";
          color = "#e9967a";
          pac = "";
          pacString = "";
          proxyDNS = true;
          include = [];
          exclude = [];
          tabProxy = [];
        }
      ];
    };
  };
  vimium = {
    id = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";
    privateAllowed = true;
    permissions = [
      "tabs"
      "bookmarks"
      "history"
      "storage"
      "sessions"
      "notifications"
      "scripting"
      "webNavigation"
      "search"
      "clipboardRead"
      "clipboardWrite"
      "<all_urls>"
      "file:///"
      "file:///*/"
    ];
  };
}
