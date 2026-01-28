{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.__cfg.opencode;

  wrappedOpencode = pkgs.symlinkJoin {
    name = "opencode-wrapped";
    paths = [pkgs.opencode]; # The package you want to wrap
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/opencode \
        ${
        if cfg.mcp.docfork.enable && cfg.mcp.docfork.apiKeyFile != null
        then ''--run 'export DOCFORK_API_KEY="$(cat ${cfg.mcp.docfork.apiKeyFile})"' ''
        else ""
      }
    '';
  };

  wrappedOpenagentsPackage = pkgs.symlinkJoin {
    name = "openagents-opencode-wrapped";
    paths = [inputs.self.packages.${pkgs.system}.openagents-opencode];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/openagents-opencode \
        ${
        if cfg.mcp.docfork.enable && cfg.mcp.docfork.apiKeyFile != null
        then ''--run 'export DOCFORK_API_KEY="$(cat ${cfg.mcp.docfork.apiKeyFile})"' ''
        else ""
      }
    '';
  };
in {
  options = {
    __cfg.opencode = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable opencode";
      };
      openagents = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable openagents-opencode parallel installation";
        };
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = wrappedOpencode;
        description = "The opencode package to use";
      };
      mcp = {
        docfork = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable Docfork mcp";
          };
          apiKeyFile = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Docfork api key file";
          };
        };
        searxng = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable searxng mcp";
          };
          url = lib.mkOption {
            type = lib.types.str;
            default = "https://searx-mcp.hastybox.com:8443/mcp";
            description = "Searxng mcp url";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.opencode = {
      enable = cfg.enable;
      package = cfg.package;

      agents = {
        documentation = ./agents/documentation.md;
      };

      settings = {
        plugin = [
          "opencode-antigravity-auth@1.3.2" # allow auth with google antigravity oauth
        ];

        mcp = {
          docfork = lib.mkIf cfg.mcp.docfork.enable {
            type = "remote";
            url = "https://mcp.docfork.com/mcp";
            enabled = true;
            headers = lib.mkIf (cfg.mcp.docfork.apiKeyFile != null) {
              "DOCFORK_CABINET" = "general";
              "DOCFORK_API_KEY" = "{env:DOCFORK_API_KEY}";
            };
          };
          searxng = lib.mkIf cfg.mcp.searxng.enable {
            type = "remote";
            url = cfg.mcp.searxng.url;
            enabled = true;
          };
        };

        permission = {
          bash = {
            "git add*" = "deny";
            "git commit*" = "deny";
            "git push*" = "deny";
            "git fetch*" = "deny";
            "git pull*" = "deny";
            "git reset*" = "deny";
            "git merge*" = "deny";
            "git rebase*" = "deny";

            "git status" = "allow";
            "git log" = "allow";
            "git diff" = "allow";
          };
        };

        provider = {
          google = import ./providers/google.nix;
        };
      };
    };

    home.packages = lib.mkIf cfg.openagents.enable [wrappedOpenagentsPackage];

    # use the same opencode package in neovim
    __cfg.neovim.opencodePackage = cfg.package;
  };
}
