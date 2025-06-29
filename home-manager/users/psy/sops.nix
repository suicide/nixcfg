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
      secrets."my_secret/key1" = {
        # sopsFile = ./secrets.yml.enc; # optionally define per-secret files

        # %r gets replaced with a runtime directory, use %% to specify a '%'
        # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
        # DARWIN_USER_TEMP_DIR) on darwin.
        path = "%r/test.txt";
      };
      secrets."ssh/homebase/privateKey" = {
        path = "%r/homebase-private-key";
      };
      secrets."ssh/homebase/publicKey" = {
        path = "%r/homebase-public-key";
      };

      secrets."ssh/github/privateKey" = {
        path = "%r/github-private-key";
      };
      secrets."ssh/github/publicKey" = {
        path = "%r/github-public-key";
      };

      secrets."ssh/bitbucket/privateKey" = {
        path = "%r/bitbucket-private-key";
      };
      secrets."ssh/bitbucket/publicKey" = {
        path = "%r/bitbucket-public-key";
      };

      secrets."ssh/remote_hop/privateKey" = {
        path = "%r/remote_hop-private-key";
      };
      secrets."ssh/remote_hop/publicKey" = {
        path = "%r/remote_hop-public-key";
      };

      secrets."ssh/remote_macarco/privateKey" = {
        path = "%r/remote_macarco-private-key";
      };
      secrets."ssh/remote_macarco/publicKey" = {
        path = "%r/remote_macarco-public-key";
      };

      secrets."ssh/unikorn/privateKey" = {
        path = "%r/unikorn-private-key";
      };
      secrets."ssh/unikorn/publicKey" = {
        path = "%r/unikorn-public-key";
      };

      secrets."ssh/homegate2/privateKey" = {
        path = "%r/homegate2-private-key";
      };
      secrets."ssh/homegate2/publicKey" = {
        path = "%r/homegate2-public-key";
      };

      secrets."ssh/thering/privateKey" = {
        path = "%r/thering-private-key";
      };
      secrets."ssh/thering/publicKey" = {
        path = "%r/thering-public-key";
      };

      secrets."ssh/luna/privateKey" = {
        path = "%r/luna-private-key";
      };
      secrets."ssh/luna/publicKey" = {
        path = "%r/luna-public-key";
      };

      secrets."ssh/deimos/privateKey" = {
        path = "%r/deimos-private-key";
      };
      secrets."ssh/deimos/publicKey" = {
        path = "%r/deimos-public-key";
      };

      secrets."ssh/ganymede/privateKey" = {
        path = "%r/ganymede-private-key";
      };
      secrets."ssh/ganymede/publicKey" = {
        path = "%r/ganymede-public-key";
      };

      secrets."ssh/ceres/privateKey" = {
        path = "%r/ceres-private-key";
      };
      secrets."ssh/ceres/publicKey" = {
        path = "%r/ceres-public-key";
      };

      secrets."ssh/auberon/privateKey" = {
        path = "%r/auberon-private-key";
      };
      secrets."ssh/auberon/publicKey" = {
        path = "%r/auberon-public-key";
      };
    };
  };
}
