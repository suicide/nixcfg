{
  lib,
  pkgs,
  config,
  ...
}: {
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

      history = {
        ignoreSpace = true;
        ignoreDups = true;
        expireDuplicatesFirst = true;

        share = true;

        size = 100000;
      };

      autocd = true;

      shellAliases = {
        "ls" = "eza";
        "l" = "ls -lahg";

        "cat" = "bat";
      };
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
    };

    programs.eza = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.bat = {
      enable = true;
    };

    home.packages = with pkgs; [
    ];
  };
}
