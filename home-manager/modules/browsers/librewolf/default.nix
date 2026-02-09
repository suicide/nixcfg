# thanks to https://gitlab.com/maximilian_dietrich/nixos/-/blob/restructure-add-workstation/modules/graphical/apps/browser/default.nix
{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: {
  config = let
    extensions = import ../firefox/extensions.nix;
  in {
    programs.librewolf = {
      enable = true;

      policies = import ../firefox/policies.nix {inherit lib extensions;};

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
}
