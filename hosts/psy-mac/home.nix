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
      settings = {
        user = {
          name = "Patrick Sy";
          email = "patrick.sy@telekom.de";
        };

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
      secrets = {
        "ssh/buildthing/privateKey" = {
          path = "%r/buildthing-private-key";
        };
        "ssh/buildthing/publicKey" = {
          path = "%r/buildthing-public-key";
        };
        "ai/gemini/api_key" = {
          path = "%r/ai-gemini-api-key";
        };
      };
    };

    __cfg.neovim = let
      secrets = "${config.home.homeDirectory}/.config/sops-nix/secrets";
    in {
      enable = true;
      useLegacyConfig = false;
      useNvf = true;
      geminiApiKey = "${secrets}/ai/gemini/api_key";
    };
  };
}
