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

    ## Get old neovim config
    home =
      {
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
      // lib.optionalAttrs cfg.useNvf {
        # defaultEditor
        sessionVariables = {EDITOR = "nvim";};

        # aliases
        shellAliases = {
          vi = "nvim";
          vim = "nvim";
          vimdiff = "nvim -d";
        };

        packages = with pkgs; [
          inputs.neovim.packages.${system}.default
        ];
      };
  };
}
