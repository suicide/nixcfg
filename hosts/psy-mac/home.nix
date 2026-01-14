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

      extraConfig = {
        vim.assistant.codecompanion-nvim = {
          setupOpts = {
            adapters = lib.mkForce (lib.mkLuaInline ''
              {
                http = {
                  devai = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                      schema = {
                        model = {
                          default = "llama-3.3-70b",
                        },
                      },
                      env = {
                        url = "https://openai-api.mms-at-work.de",
                      },
                    })
                  end,

                },
              }
            '');

            strategies = {
              chat = {
                adapter = lib.mkForce "devai";
              };
              inline = {
                adapter = lib.mkForce "devai";
              };
            };
          };
        };
      };
    };

    __cfg.opencode = {
      mcp = {
        searxng.enable = false;
        docfork.apiKeyFile = lib.mkForce null;
      };
    };

    programs.opencode = {
      settings = {
        provider = {
          mmsai = {
            "npm" = "@ai-sdk/openai-compatible";
            "name" = "MMS AI";
            "options" = {
              "baseURL" = "https://openai-api.mms-at-work.de/v1";
            };
            "models" = {
              "Devstral-Small-2-24B-Instruct-2512" = {
                name = "Devstral Small 24B (Code Optimized)";
                "limit" = {
                  "context" = 128000;
                  "output" = 32768;
                };
              };
              "codellama-34b" = {
                name = "CodeLlama 34B";
                "limit" = {
                  "context" = 128000;
                  "output" = 32768;
                };
              };
            };
          };
        };
      };
    };
  };
}
