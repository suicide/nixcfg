{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  enableSops = true;
in {
  config = {
    home = {
      username = "psy";
      homeDirectory = "/Users/psy";
    };

    programs.git = {
      userName = "Patrick Sy";
      userEmail = "patrick.sy@telekom.de";

      extraConfig = {
        user.signingkey = "DDDC8EC51823195E";
      };
    };

    __cfg.sops.enable = enableSops;

    programs.ssh = let
      secrets = "~/.config/sops-nix/secrets/ssh";
    in {
      extraConfig = ''
        Include ${config.home.homeDirectory}/.colima//ssh_config
      '';

      matchBlocks = lib.mkIf enableSops {
        "edp.buildth.ing" = {
          hostname = "edp.buildth.ing";
          identityFile = "${secrets}/buildthing/privateKey";
          user = "git";
        };
      };
    };

    # secrets
    sops = lib.mkIf enableSops {
      defaultSopsFile = ./secrets.yaml;
      secrets."ssh/buildthing/privateKey" = {
        path = "%r/buildthing-private-key";
      };
      secrets."ssh/buildthing/publicKey" = {
        path = "%r/buildthing-public-key";
      };
    };
  };
}
