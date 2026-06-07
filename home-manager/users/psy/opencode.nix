{
  lib,
  pkgs,
  config,
  ...
}: let
  secrets = "~/.config/sops-nix/secrets";
in {
  config = {
    __cfg.opencode = {};

    programs.opencode = {
      settings = {
        agent = let
          lightweightModel = "opencode-go/deepseek-v4-flash";
          mediumModel = "opencode-go/deepseek-v4-pro";
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
            model = lightweightModel;
          };
          codereviewer = {
            model = mediumModel;
            permission = {
              edit = "deny";
            };
          };
        };
      };
    };
  };
}
