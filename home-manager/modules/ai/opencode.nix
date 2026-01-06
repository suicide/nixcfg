{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    programs.opencode = {
      enable = true;

      settings = {
        plugin = [
          "opencode-gemini-auth@1.3.6" # allow auth with gemini oauth
        ];
      };
    };
  };
}
