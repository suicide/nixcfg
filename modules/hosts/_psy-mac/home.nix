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

      settings = lib.mkIf enableSops {
        "edp.buildth.ing" = {
          HostName = "edp.buildth.ing";
          IdentityFile = "${secrets}/buildthing/privateKey";
          User = "git";
        };
      };
    };

    __cfg.neovim = {
      enable = true;
    };

    __cfg.opencode = {
      mcp = {
        searxng.enable = false;
      };
    };

    programs.opencode = {
      settings = {
        provider = (import ./ai/mmsai.nix) // (import ./ai/llmchat.nix);
        agent = let
          lightweightModel = "github-copilot/gpt-5.6-luna";
          mediumWeightModel = "github-copilot/gpt-5.6-terra";
        in {
          # Built in
          explore = {
            model = lightweightModel;
          };
          general = {
            model = lightweightModel;
          };

          # extras

          documentation = {
            model = mediumWeightModel;
          };
          codereviewer = {
            model = "github-copilot/claude-opus-5";
            permission = {
              edit = "deny";
            };
          };
          implementer = {
            model = lightweightModel;
          };
        };
      };
    };
  };
}
