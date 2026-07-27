{lib, ...}: {
  internal.modules = {
    home.antigravity-cli = {
      lib,
      pkgs,
      config,
      inputs,
      ...
    }: let
      cfg = config.__cfg.antigravity-cli;
    in {
      options = {
        __cfg.antigravity-cli = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable antigravity-cli, a Gemini client for the terminal.";
          };
        };
      };

      config = lib.mkIf cfg.enable {
        programs.antigravity-cli = {
          enable = cfg.enable;

          settings = {
            context = {
              loadMemoryFromIncludeDirectories = true;
            };
            general = {
              preferredEditor = "nvim";
              previewFeatures = true;
              vimMode = true;
            };
            privacy = {
              usageStatisticsEnabled = false;
            };
            security = {
              auth = {
                selectedType = "oauth-personal";
              };
            };
          };
        };
      };
    };

    nixos.antigravity-cli = {config, ...}: {
      config = {
        environment.persistence.${config.__cfg.impermanence.persistDir} = {
          users.${config.__cfg.mainUser} = {
            directories = [
              ".gemini" # gemini-cli auth
            ];
          };
        };
      };
    };
  };
}
