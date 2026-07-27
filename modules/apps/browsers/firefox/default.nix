{...}: {
  internal.modules = {
    home.firefox = {
      config,
      pkgs,
      inputs,
      lib,
      ...
    }: let
      extensions = import ./_extensions.nix {enabledProxy = config.__cfg.browser.firefox.foxyproxy.enabledProxy;};
    in {
      options.__cfg.browser.firefox.foxyproxy.enabledProxy = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Title of the FoxyProxy proxy to auto-enable in Firefox (mode 3, all URLs). null = leave unchanged.";
      };

      # thanks to https://gitlab.com/maximilian_dietrich/nixos/-/blob/restructure-add-workstation/modules/graphical/apps/browser/default.nix
      config = {
        programs.firefox = {
          enable = true;

          # explicitly setting new config path, since we are on home.stateVersion < 26.05
          configPath = "${config.xdg.configHome}/mozilla/firefox";

          policies = import ./_policies.nix {inherit lib extensions;};

          profiles.default = {
            settings = {
              "extensions.autoDisableScopes" = 0;
            };
            extensions = {
              packages = builtins.map (ext: inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}.${ext}) (
                builtins.attrNames extensions
              );
              force = true;
              settings = lib.mapAttrs' (
                _name: value:
                  lib.nameValuePair value.id {
                    inherit (value) settings;
                    force = true;
                  }
              ) (lib.filterAttrs (_name: val: val ? settings && val.settings != {}) extensions);
            };
          };
        };
      };
    };

    nixos.firefox = {config, ...}: {
      config = {
        environment.persistence.${config.__cfg.impermanence.persistDir} = {
          users.${config.__cfg.mainUser} = {
            directories = [
              ".config/mozilla"
            ];
          };
        };
      };
    };
  };
}
