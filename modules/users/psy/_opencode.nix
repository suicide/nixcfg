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
          lightweightModel = "opencode-go/hy3";
          lightweightModel2 = "opencode-go/muse-spark-1.2-contributor";
          mediumModel = "openai/gpt-5.6-luna";
          docsModel = mediumModel;
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
            model = lightweightModel2;
          };
        };
      };
    };
  };
}
