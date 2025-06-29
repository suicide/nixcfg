{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: {
  config = {
    programs.firefox = {
      enable = true;

      profiles.default = {
        settings = {
          "extensions.autoDisableScopes" = 0;
        };

        extensions = {
          packages = with inputs.firefox-addons.packages.${pkgs.system}; [
            ublock-origin
            darkreader
            # switchyomega
            foxyproxy-standard
            vimium
          ];

          force = true;
        };
      };
    };

    home.activation.ensureFirefoxPrivateExtensions = let
      configDir =
        if pkgs.stdenv.isDarwin
        then lib.escapeShellArg "Library/Application Support/Firefox/Profiles"
        else ".mozilla/firefox";
      profileDir = "${configDir}/default/";
      targetFile = "${profileDir}/extension-preferences.json";
      addonIds = [
        "addon@darkreader.org"
        "uBlock0@raymondhill.net"
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" # vimium
        # "switchyomega@feliscatus.addons.mozilla.org"
        "foxyproxy@eric.h.jung"
      ];
      addonConfig = name:
        lib.replaceStrings ["\n"] [""] ''
          "${name}": {
            "permissions": [
              "internal:privateBrowsingAllowed"
            ],
            "origins": [],
            "data_collection": []
          },
        '';
      addons = "{" + lib.concatStrings (map addonConfig addonIds) + "}";
      jq = lib.getExe pkgs.jq;
    in
      lib.mkIf config.programs.firefox.enable
      ''
        install -d ${profileDir}

        originalContent=`cat ${targetFile} 2>/dev/null | ${jq} -e '.' 2>/dev/null || echo '{}'`
        addonsAdded=`echo $originalContent | ${jq} '. * ${addons}'`
        echo $addonsAdded > ${targetFile}
      '';
  };
}
