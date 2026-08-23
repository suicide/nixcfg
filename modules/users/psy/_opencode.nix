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
          exploreModel = "opencode-go/hy3";
          implementerModel = "opencode-go/mimo-v2.5";
          generalModel = implementerModel;
          reviewerModel = "openai/gpt-5.6-luna";
          docsModel = reviewerModel;
        in {
          # Built in
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
