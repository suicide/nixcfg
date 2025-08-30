{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: {
  config = {
    programs.neovim = {
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
    home.file."${config.home.homeDirectory}/.config/nvim" = {
      source = pkgs.fetchFromGitHub {
        owner = "suicide";
        repo = "nvim-conf";
        rev = "9f04856be56e89455b7967fed9779ae57facc84f";
        hash = "sha256-PX6Ot8gQj4dm+FgYFaJxbfPww4UYnbMbbGs5pln6uZE=";
      };
      recursive = true;
    };

    # home = {
    #   # defaultEditor
    #   sessionVariables = { EDITOR = "nvim"; };
    #
    #   # aliases
    #   shellAliases = {
    #     vi = "nvim";
    #     vim = "nvim";
    #     vimdiff = "nvim -d";
    #   };
    #
    #   packages = with pkgs; [
    #     inputs.neovim.packages.${system}.default
    #   ];
    # };
  };
}
