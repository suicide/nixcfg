{ lib, pkgs, config, ... }:

{
  config = {
    programs.zsh = {
      enable = true;

      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;

      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "copyfile"
          "cp"
          # "direnv"
          "docker"
          "docker-compose"
          "extract"
          "git"
          "gradle"
          "kubectl"
          "mvn"
          "rsync"
          "sudo"
          "vi-mode"
          "rust"
          "wd"
          # "zsh-autosuggestions"
          # "zsh-syntax-highlighting"
        ];
      };
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
    };

    home.packages = with pkgs; [ 
    ];
  };
}

