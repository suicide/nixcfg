{
  lib,
  pkgs,
  config,
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
      ];
    };

    ## Get old neovim config
    home.file."${config.home.homeDirectory}/.config/nvim" = {
      source = pkgs.fetchFromGitHub {
        owner = "suicide";
        repo = "nvim-conf";
        rev = "84d387983a8db8aefc0cfad10f03bb034ddb31d9";
        hash = "sha256-Js7+ANGVPdu9UAGJpAwIbdBm343IgbQkPsZCePj6uyw=";
      };
      recursive = true;
    };
  };
}
