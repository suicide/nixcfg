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

      antidote = {
        enable = true;
        plugins = [
          "jeffreytse/zsh-vi-mode"
          "ohmyzsh/ohmyzsh path:plugins/git"
          "ohmyzsh/ohmyzsh path:plugins/extract"
          "ohmyzsh/ohmyzsh path:plugins/sudo"
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

      initContent = lib.mkMerge [
        (lib.mkOrder 540 ''
          # zsh-vi-mode replaces Ctrl-R in insert mode, so restore the fzf
          # history widget once it finishes initializing.
          typeset -ga zvm_after_init_commands

          __cfg_after_zvm_init() {
            bindkey -M emacs '^R' fzf-history-widget
            bindkey -M viins '^R' fzf-history-widget
            bindkey -M vicmd '^R' fzf-history-widget
          }

          zvm_after_init_commands+=(__cfg_after_zvm_init)
        '')

        (lib.mkOrder 800 ''
          # Use fzf-tab for interactive completion while preserving zsh's matcher settings.
          source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

          zstyle ':completion:*' menu no
          zstyle ':completion:*' matcher-list \
            'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
            'r:|=*' 'l:|=* r:|=*'
          zstyle ':completion:*' special-dirs true
          zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
          zstyle ':completion:*' use-cache yes

          zstyle ':fzf-tab:*' fzf-flags --bind=tab:down,shift-tab:up
          zstyle ':fzf-tab:*' switch-group '<' '>'
        '')

        (lib.mkOrder 900 ''
          source ${pkgs.fzf}/share/fzf/key-bindings.zsh
        '')

        ''
          # Dropped alias-heavy OMZ plugins to re-evaluate later if missed:
          # copyfile cp docker docker-compose kubectl mvn rsync rust wd gradle
          autoload -Uz edit-command-line
          zle -N edit-command-line
          bindkey '^X^E' edit-command-line
        ''
      ];
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = false;
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
