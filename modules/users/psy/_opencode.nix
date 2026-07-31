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
          mediumModel = "opencode-go/mimo-v2.5-pro";
          docsModel = "opencode-go/deepseek-v4-pro";
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
            model = docsModel;
          };
          codereviewer = {
            model = mediumModel;
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
