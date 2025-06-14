{ lib, pkgs, config, ... }:

{
  config = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
      extraPackages = with pkgs; [
        ripgrep
        gcc
        cargo
        nixd
      ];

    };

    ## Get old neovim config
    home.file."${config.home.homeDirectory}/.config/nvim" = {
      source = pkgs.fetchFromGitHub {
        owner = "suicide";
        repo = "nvim-conf";
        rev = "0f2ba608ce1ad814672f80a893d47ef3870fa547";
        hash = "sha256-jMvij0OnbzSzREWBiMz3ccKKome8fxRmyPF+v/Nbl0E=";
      };
      recursive = true;
    };
  };
}
