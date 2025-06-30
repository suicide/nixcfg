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
        marksman
      ];
    };

    ## Get old neovim config
    home.file."${config.home.homeDirectory}/.config/nvim" = {
      source = pkgs.fetchFromGitHub {
        owner = "suicide";
        repo = "nvim-conf";
        rev = "74858fe587821e91ceea7077a2cf77fcae5ad178";
        hash = "sha256-JMZZWpEA3J1md+O1FmGkL5PigdJsf/E0IkPd1pgRrBw=";
      };
      recursive = true;
    };
  };
}
