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
          exploreModel = generalModel;
          buildModel = "opencode-go/deepseek-v4-flash";
          implementerModel = buildModel;
          generalModel = "opencode-go/mimo-v2.5";
          reviewerModel = "openai/gpt-5.6-luna";
          docsModel = reviewerModel;
        in {
          # Built in
          build = {
            model = buildModel;
          };
          explore = {
            model = exploreModel;
          };
          general = {
            model = generalModel;
          };

          # extras

          documentation = {
            model = docsModel;
          };
          codereviewer = {
            model = reviewerModel;
            permission = {
              edit = "deny";
            };
          };
          implementer = {
            model = implementerModel;
          };
        };
      };
    };
  };
}
