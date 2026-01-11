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

        permission = {
          bash = {
            "git commit*" = "deny";
            "git add*" = "deny";
            "git push*" = "deny";
            "git status" = "allow";
            "git log" = "allow";
            "git diff" = "allow";
          };
        };
      };
    };
  };
}
