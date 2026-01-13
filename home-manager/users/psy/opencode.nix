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
  };
}
