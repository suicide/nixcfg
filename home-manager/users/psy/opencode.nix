{
  lib,
  pkgs,
  config,
  ...
}: let
  secrets = "~/.config/sops-nix/secrets";
in {
  config = {
    __cfg.opencode = {
      mcp = {
        docfork.apiKeyFile = "${secrets}/mcp/docfork/api_key";
      };
    };

    programs.opencode = {
      settings = {
        agent = let
          lightweightModel = "opencode-go/deepseek-v4-flash";
        in {
          # Built in
          explore = {
            model = lightweightModel;
          };
          general = {
            model = lightweightModel;
          };
          scout = {
            model = lightweightModel;
          };

          # extras

          documentation = {
            model = lightweightModel;
          };
        };
      };
    };
  };
}
