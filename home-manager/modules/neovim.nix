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
        fzf
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
        rev = "656158c689d956ffcd90dda6bfe3c64118c7f104";
        hash = "sha256-d81O23g0aTUSHKwj2Yoi6pqfSQtRrMbZzbl6zr2IyzM=";
      };
      recursive = true;
    };
  };
}
