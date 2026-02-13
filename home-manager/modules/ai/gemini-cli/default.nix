{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.__cfg.gemini-cli;
in {
  options = {
    __cfg.gemini-cli = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable gemini-cli";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gemini-cli = {
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
}
