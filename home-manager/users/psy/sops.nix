# general home sops config, user secrets are defined in user folder
{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.__cfg.sops;
in {
  config = {
    sops = lib.mkIf (cfg.enable) {
      defaultSopsFile = ./secrets.yaml;
      secrets = {
        "my_secret/key1" = {
          # sopsFile = ./secrets.yml.enc; # optionally define per-secret files

          # %r gets replaced with a runtime directory, use %% to specify a '%'
          # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
          # DARWIN_USER_TEMP_DIR) on darwin.
          path = "%r/test.txt";
        };
        "ai/gemini/api_key" = {
          path = "%r/ai-gemini-api-key";
        };
        "ssh/homebase/privateKey" = {
          path = "%r/homebase-private-key";
        };
        "ssh/homebase/publicKey" = {
          path = "%r/homebase-public-key";
        };

        "ssh/github/privateKey" = {
          path = "%r/github-private-key";
        };
        "ssh/github/publicKey" = {
          path = "%r/github-public-key";
        };

        "ssh/bitbucket/privateKey" = {
          path = "%r/bitbucket-private-key";
        };
        "ssh/bitbucket/publicKey" = {
          path = "%r/bitbucket-public-key";
        };

        "ssh/remote_hop/privateKey" = {
          path = "%r/remote_hop-private-key";
        };
        "ssh/remote_hop/publicKey" = {
          path = "%r/remote_hop-public-key";
        };

        "ssh/remote_macarco/privateKey" = {
          path = "%r/remote_macarco-private-key";
        };
        "ssh/remote_macarco/publicKey" = {
          path = "%r/remote_macarco-public-key";
        };

        "ssh/unikorn/privateKey" = {
          path = "%r/unikorn-private-key";
        };
        "ssh/unikorn/publicKey" = {
          path = "%r/unikorn-public-key";
        };

        "ssh/homegate2/privateKey" = {
          path = "%r/homegate2-private-key";
        };
        "ssh/homegate2/publicKey" = {
          path = "%r/homegate2-public-key";
        };

        "ssh/thering/privateKey" = {
          path = "%r/thering-private-key";
        };
        "ssh/thering/publicKey" = {
          path = "%r/thering-public-key";
        };

        "ssh/luna/privateKey" = {
          path = "%r/luna-private-key";
        };
        "ssh/luna/publicKey" = {
          path = "%r/luna-public-key";
        };

        "ssh/deimos/privateKey" = {
          path = "%r/deimos-private-key";
        };
        "ssh/deimos/publicKey" = {
          path = "%r/deimos-public-key";
        };

        "ssh/ganymede/privateKey" = {
          path = "%r/ganymede-private-key";
        };
        "ssh/ganymede/publicKey" = {
          path = "%r/ganymede-public-key";
        };

        "ssh/ceres/privateKey" = {
          path = "%r/ceres-private-key";
        };
        "ssh/ceres/publicKey" = {
          path = "%r/ceres-public-key";
        };

        "ssh/auberon/privateKey" = {
          path = "%r/auberon-private-key";
        };
        "ssh/auberon/publicKey" = {
          path = "%r/auberon-public-key";
        };
      };
    };
  };
}
