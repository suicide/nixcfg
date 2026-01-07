{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    programs.opencode = {
      enable = true;

      agents = {
        documentation = ./agents/documentation.md;
      };

      settings = {
        plugin = [
          "opencode-gemini-auth@1.3.7" # allow auth with gemini oauth
        ];
      };
    };
  };
}
