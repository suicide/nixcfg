{lib, ...}: {
  perSystem = {pkgs, ...}: let
    permissions = import ./_permissions.nix;
    testConfig = pkgs.writeText "opencode-permissions.json" (builtins.toJSON {
      permissions = permissions.shared;
      agents = {
        codereviewer.permissions = permissions.nonEditing;
        explore.permissions = permissions.nonEditing;
      };
      experimental.subagent_depth = 2;
    });
  in {
    checks.opencode-permissions =
      pkgs.runCommand "opencode-permissions" {
        nativeBuildInputs = [pkgs.python3];
      } ''
        python ${./tests/permissions.py} < ${testConfig}
        touch "$out"
      '';
  };

  internal.modules = {
    home.opencode = {
      lib,
      pkgs,
      config,
      ...
    }: let
      cfg = config.__cfg.opencode;
      permissions = import ./_permissions.nix;

      wrappedOpencode = pkgs.symlinkJoin {
        name = "opencode-wrapped-${pkgs.opencode.version}";
        paths = [pkgs.opencode];

        # Keep Home Manager's OpenCode version detection and schema validation
        # working through the wrapper.
        inherit (pkgs.opencode) version meta passthru;

        buildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/opencode \
            --prefix PATH : ${lib.makeBinPath [pkgs.gh]}
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
          package = lib.mkOption {
            type = lib.types.package;
            default = wrappedOpencode;
            description = "The opencode package to use";
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

          validateFiles.config = true;

          agents = {
            codereviewer = ./agents/codereviewer.md;
            documentation = ./agents/documentation.md;
            implementer = ./agents/implementer.md;
            orchestrator-build = ./agents/orchestrator-build.md;
          };

          commands = {
            commitmsg = ./commands/commitmsg.md;
          };

          settings = {
            plugins = [
              (toString ./plugins/builtin-agent-append)
            ];

            agents = {
              codereviewer.permissions = permissions.nonEditing;
              explore = {
                description = "Read-only repository and technical research. Use for locating unfamiliar code, tracing dependencies or execution paths, investigating architecture, and answering questions requiring iterative or multi-file discovery. Returns concise findings with file paths, key references, and uncertainties.";
                permissions = permissions.nonEditing;
              };
              plan = {
                color = "#fab283";
              };
              build = {
                color = "#5c9cf5";
              };
              orchestrator-build = {
                color = "#9d7cd8";
              };
            };

            mcp.servers = {
              searxng = lib.mkIf cfg.mcp.searxng.enable {
                type = "remote";
                url = cfg.mcp.searxng.url;
              };
              grep_app = lib.mkIf cfg.mcp.grepApp.enable {
                type = "remote";
                url = cfg.mcp.grepApp.url;
              };
            };

            permissions = permissions.shared;

            experimental = {
              todo = true;
              subagent_depth = 2;
            };
          };

          context = ''
            # General Guidelines

            ## Nix policy

            NixOS / nix-darwin system.
            Use Nix for any missing tool: `nix run nixpkgs#tool` or add to flake.
          '';
        };

        # Keep sharing the package with neovim. The packaged opencode.nvim still
        # targets the V1 server API and needs a separate migration.
        __cfg.neovim.opencodePackage = cfg.package;
      };
    };

    nixos.opencode = {config, ...}: {
      config = {
        environment.persistence.${config.__cfg.impermanence.persistDir} = {
          users.${config.__cfg.mainUser} = {
            directories = [
              ".local/share/opencode" # opencode (auth in `auth.json`)
            ];
          };
        };
      };
    };
  };
}
