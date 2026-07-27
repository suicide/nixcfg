# Darwin-specific SOPS user secrets — mutually exclusive with _sops.nix.
# This module is imported only on macOS; shared Linux declarations in _sops.nix
# do not apply here.
{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.__cfg.sops;
  macSopsFile = ../../../secrets/users/psy-mac.yaml;
in {
  config = lib.mkIf (cfg.enable && pkgs.stdenv.hostPlatform.isDarwin) {
    sops.secrets = {
      "ssh/buildthing/privateKey" = {
        sopsFile = macSopsFile;
        path = "%r/buildthing-private-key";
      };
      "ssh/buildthing/publicKey" = {
        sopsFile = macSopsFile;
        path = "%r/buildthing-public-key";
      };
      "ai/gemini/api_key" = {
        sopsFile = macSopsFile;
        path = "%r/ai-gemini-api-key";
      };
    };
  };
}
