# Shared Linux user SOPS secrets.
# Every secret below *must* set `sopsFile` explicitly because the enclosing
# module does not define a global `defaultSopsFile` — the path is repeated
# per-entry for clarity and to mirror the pattern used by Mac-only leaves.
{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.__cfg.sops;
  userSopsFile = ../../../secrets/users/psy.yaml;
in {
  config = {
    sops = lib.mkIf (cfg.enable) {
      secrets = {
        "my_secret/key1" = {
          # sopsFile = ./secrets.yml.enc; # optionally define per-secret files
          sopsFile = userSopsFile;

          # %r gets replaced with a runtime directory, use %% to specify a '%'
          # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
          # DARWIN_USER_TEMP_DIR) on darwin.
          path = "%r/test.txt";
        };
        "ai/gemini/api_key" = {
          sopsFile = userSopsFile;
          path = "%r/ai-gemini-api-key";
        };
        "ai/github_copilot/token" = {
          sopsFile = userSopsFile;
          path = "%r/ai-github-copilot-token";
        };
        "ssh/homebase/privateKey" = {
          sopsFile = userSopsFile;
          path = "%r/homebase-private-key";
        };
        "ssh/homebase/publicKey" = {
          sopsFile = userSopsFile;
          path = "%r/homebase-public-key";
        };

        "ssh/github/privateKey" = {
          sopsFile = userSopsFile;
          path = "%r/github-private-key";
        };
        "ssh/github/publicKey" = {
          sopsFile = userSopsFile;
          path = "%r/github-public-key";
        };

        "ssh/codeberg/privateKey" = {
          sopsFile = userSopsFile;
          path = "%r/codeberg-private-key";
        };
        "ssh/codeberg/publicKey" = {
          sopsFile = userSopsFile;
          path = "%r/codeberg-public-key";
        };

        "ssh/codeberg-ler/privateKey" = {
          sopsFile = userSopsFile;
          path = "%r/codeberg-ler-private-key";
        };
        "ssh/codeberg-ler/publicKey" = {
          sopsFile = userSopsFile;
          path = "%r/codeberg-ler-public-key";
        };

        "ssh/bitbucket/privateKey" = {
          sopsFile = userSopsFile;
          path = "%r/bitbucket-private-key";
        };
        "ssh/bitbucket/publicKey" = {
          sopsFile = userSopsFile;
          path = "%r/bitbucket-public-key";
        };

        "ssh/remote_hop/privateKey" = {
          sopsFile = userSopsFile;
          path = "%r/remote_hop-private-key";
        };
        "ssh/remote_hop/publicKey" = {
          sopsFile = userSopsFile;
          path = "%r/remote_hop-public-key";
        };

        "ssh/remote_macarco/privateKey" = {
          sopsFile = userSopsFile;
          path = "%r/remote_macarco-private-key";
        };
        "ssh/remote_macarco/publicKey" = {
          sopsFile = userSopsFile;
          path = "%r/remote_macarco-public-key";
        };

        "ssh/unikorn/privateKey" = {
          sopsFile = userSopsFile;
          path = "%r/unikorn-private-key";
        };
        "ssh/unikorn/publicKey" = {
          sopsFile = userSopsFile;
          path = "%r/unikorn-public-key";
        };

        "ssh/homegate2/privateKey" = {
          sopsFile = userSopsFile;
          path = "%r/homegate2-private-key";
        };
        "ssh/homegate2/publicKey" = {
          sopsFile = userSopsFile;
          path = "%r/homegate2-public-key";
        };

        "ssh/thering/privateKey" = {
          sopsFile = userSopsFile;
          path = "%r/thering-private-key";
        };
        "ssh/thering/publicKey" = {
          sopsFile = userSopsFile;
          path = "%r/thering-public-key";
        };

        "ssh/luna/privateKey" = {
          sopsFile = userSopsFile;
          path = "%r/luna-private-key";
        };
        "ssh/luna/publicKey" = {
          sopsFile = userSopsFile;
          path = "%r/luna-public-key";
        };

        "ssh/deimos/privateKey" = {
          sopsFile = userSopsFile;
          path = "%r/deimos-private-key";
        };
        "ssh/deimos/publicKey" = {
          sopsFile = userSopsFile;
          path = "%r/deimos-public-key";
        };

        "ssh/ganymede/privateKey" = {
          sopsFile = userSopsFile;
          path = "%r/ganymede-private-key";
        };
        "ssh/ganymede/publicKey" = {
          sopsFile = userSopsFile;
          path = "%r/ganymede-public-key";
        };

        "ssh/ceres/privateKey" = {
          sopsFile = userSopsFile;
          path = "%r/ceres-private-key";
        };
        "ssh/ceres/publicKey" = {
          sopsFile = userSopsFile;
          path = "%r/ceres-public-key";
        };

        "ssh/auberon/privateKey" = {
          sopsFile = userSopsFile;
          path = "%r/auberon-private-key";
        };
        "ssh/auberon/publicKey" = {
          sopsFile = userSopsFile;
          path = "%r/auberon-public-key";
        };

        "ssh/outterworld/host" = {
          sopsFile = userSopsFile;
        };
        "ssh/outterworld/privateKey" = {
          sopsFile = userSopsFile;
          path = "%r/outterworld-private-key";
        };
        "ssh/outterworld/publicKey" = {
          sopsFile = userSopsFile;
          path = "%r/outterworld-public-key";
        };

        "ssh/outterworld2/host" = {
          sopsFile = userSopsFile;
        };
        "ssh/outterworld2/privateKey" = {
          sopsFile = userSopsFile;
          path = "%r/outterworld2-private-key";
        };
        "ssh/outterworld2/publicKey" = {
          sopsFile = userSopsFile;
          path = "%r/outterworld2-public-key";
        };

        "ssh/outterworld3/host" = {
          sopsFile = userSopsFile;
        };
        "ssh/outterworld3/privateKey" = {
          sopsFile = userSopsFile;
          path = "%r/outterworld3-private-key";
        };
        "ssh/outterworld3/publicKey" = {
          sopsFile = userSopsFile;
          path = "%r/outterworld3-public-key";
        };
      };
    };
  };
}
