{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.__cfg.neovim;
in {
  options = {
    __cfg.neovim = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable custom neovim";
      };
      useLegacyConfig = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Use legacy neovim config";
      };
      useNvf = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use NVF based neovim config";
      };
      extraConfig = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Extra NVF vim config to apply, overrides may be necessary";
        example = {
          vim.utility.oil-nvim = {
            enable = lib.mkForce false;
          };
        };
      };
      geminiApiKey = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Gemini API key file for neovim plugin";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.useLegacyConfig && cfg.useNvf);
        message = "Only one kind of neovim config is allowed, either nvf or legacy";
      }
    ];

    programs.neovim = lib.mkIf (!cfg.useNvf) {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
      withPython3 = true;
      extraPackages = with pkgs; [
        ripgrep
        gcc
        cargo
        nixd
        python3
        marksman
      ];
    };

    home =
      {
        ## Get old neovim config
        file = lib.mkIf cfg.useLegacyConfig {
          "${config.home.homeDirectory}/.config/nvim" = {
            source = pkgs.fetchFromGitHub {
              owner = "suicide";
              repo = "nvim-conf";
              rev = "9f04856be56e89455b7967fed9779ae57facc84f";
              hash = "sha256-PX6Ot8gQj4dm+FgYFaJxbfPww4UYnbMbbGs5pln6uZE=";
            };
            recursive = true;
          };
        };
      }
      // lib.optionalAttrs cfg.useNvf (let
        defaultConfig = {
          __cfg = {
            opencode = {
              # enforce same opencode package
              opencodePackage = pkgs.opencode;
            };
          };
        };
        nvim = inputs.neovim.packages.${pkgs.system}.neovimCustom {
          extraConfig = defaultConfig // cfg.extraConfig;
        };
        nvimOverridden = pkgs.symlinkJoin {
          name = "neovim-vars-wrapped";
          paths = [nvim];
          buildInputs = [pkgs.makeWrapper];
          postBuild = ''
            wrapProgram $out/bin/nvim \
              --set GEMINI_API_KEY_FILE "${cfg.geminiApiKey or ""}"
          '';
        };
      in {
        # nvf based config

        # defaultEditor
        sessionVariables = {
          EDITOR = "nvim";
        };

        # aliases
        shellAliases = {
          vi = "nvim";
          vim = "nvim";
          vimdiff = "nvim -d";
        };

        packages = [
          nvimOverridden
        ];
      });
  };
}
