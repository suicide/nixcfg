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
        --prefix PATH : ${lib.makeBinPath [pkgs.gh]} \
        ${""}
    '';
  };

  wrappedOpenagentsPackage = pkgs.symlinkJoin {
    name = "openagents-opencode-wrapped";
    paths = [inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.openagents-opencode];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/openagents-opencode \
        ${""}
    '';
  };
  antigravityAuthPackageJson = builtins.fromJSON (
    builtins.readFile "${inputs.opencode-antigravity-auth}/package.json"
  );
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
      provider = {
        google-antigravity = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable google antigravity oauth provider";
          };
        };
      };
      mcp = {
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
        grepApp = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable grep_app mcp";
          };
          url = lib.mkOption {
            type = lib.types.str;
            default = "https://mcp.grep.app";
            description = "grep_app mcp url";
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
        codereviewer = ./agents/codereviewer.md;
        documentation = ./agents/documentation.md;
        implementer = ./agents/implementer.md;
        orchestrator-build = ./agents/orchestrator-build.md;
      };

      settings = {
        plugin =
          [
            "./plugins/builtin-agent-append.ts"
          ]
          ++ lib.optionals cfg.provider.google-antigravity.enable
          [
            "${antigravityAuthPackageJson.name}@${antigravityAuthPackageJson.version}" # allow auth with google antigravity oauth
          ];

        agent = {
          plan = {
            color = "primary";
          };
          build = {
            color = "secondary";
          };
          orchestrator-build = {
            color = "accent";
          };
        };

        mcp = {
          searxng = lib.mkIf cfg.mcp.searxng.enable {
            type = "remote";
            url = cfg.mcp.searxng.url;
            enabled = true;
          };
          grep_app = lib.mkIf cfg.mcp.grepApp.enable {
            type = "remote";
            url = cfg.mcp.grepApp.url;
            enabled = true;
          };
        };

        permission = {
          bash = {
            # "git add*" = "deny";
            # "git commit*" = "deny";
            "git push*" = "deny";
            # "git fetch*" = "deny";
            # "git pull*" = "deny";
            # "git reset*" = "deny";
            # "git merge*" = "deny";
            # "git rebase*" = "deny";

            "git status" = "allow";
            "git log" = "allow";
            "git diff" = "allow";
            "gh *" = "allow";
          };
        };

        provider = {
          google = lib.mkIf cfg.provider.google-antigravity.enable (import ./providers/google.nix);
        };
      };

      context = ''
        # General Guidelines

        ## Nix policy

        NixOS / nix-darwin system.
        Use Nix for any missing tool: `nix run nixpkgs#tool` or add to flake.
      '';
    };

    home.packages = lib.mkIf cfg.openagents.enable [wrappedOpenagentsPackage];

    xdg.configFile."opencode/plugins/builtin-agent-append.ts" = {
      source = ./plugins/builtin-agent-append.ts;
    };

    # use the same opencode package in neovim
    __cfg.neovim.opencodePackage = cfg.package;
  };
}
