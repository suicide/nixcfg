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
          "${pkgs.zsh-vi-mode}/share/zsh-vi-mode"
          "${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/git"
          "${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/extract"
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

      # Cache compinit per host and zsh version. In practice this also tends
      # to invalidate naturally across Nix config changes, because completion
      # sources in fpath come from versioned Nix store paths that change when
      # plugin/package inputs change. If completion ever looks stale, remove
      # ~/.zcompdump-<host>-<zsh_version> and its .zwc to force a rebuild.
      completionInit = ''
        autoload -Uz compinit
        _comp_dumpfile="''${HOME}/.zcompdump-''${HOST}-''${ZSH_VERSION}"
        compinit -i -d "''${_comp_dumpfile}"
        if [[ -s "''${_comp_dumpfile}" && ( ! -s "''${_comp_dumpfile}.zwc" || "''${_comp_dumpfile}" -nt "''${_comp_dumpfile}.zwc" ) ]]; then
          zcompile "''${_comp_dumpfile}"
        fi
        unset _comp_dumpfile
      '';

      shellAliases = {
        "ls" = "eza";
        "l" = "ls -lahg";

        "cat" = "bat";

        "rsync-copy" = "rsync -avz --progress -h";
        "rsync-move" = "rsync -avz --progress -h --remove-source-files";
        "rsync-update" = "rsync -avzu --progress -h";
        "rsync-synchronize" = "rsync -avzu --delete --progress -h";
      };

      initContent = lib.mkMerge [
        (lib.mkOrder 539 ''
          # Disable zsh-vi-mode system clipboard integration.
          # Clipboard is handled by wl-clipboard/wl-clip-persist/cliphist at the
          # compositor level; zsh-vi-mode should not interfere.
          ZVM_SYSTEM_CLIPBOARD_ENABLED=false
        '')
        (lib.mkOrder 540 ''
          # zsh-vi-mode replaces Ctrl-R in insert mode, so restore the fzf
          # history widget once it finishes initializing.
          typeset -ga zvm_after_init_commands

          __cfg_after_zvm_init() {
            bindkey -M emacs '^R' fzf-history-widget
            bindkey -M viins '^R' fzf-history-widget
            bindkey -M vicmd '^R' fzf-history-widget
          }

          __cfg_enable_paste_quoting() {
            # Restore URL quoting on paste (like omz lib/misc.zsh).
            autoload -Uz bracketed-paste-magic
            zle -N bracketed-paste bracketed-paste-magic

            autoload -Uz url-quote-magic
            zle -N self-insert url-quote-magic

            zstyle ':bracketed-paste-magic' paste-init backward-extend-paste
          }

          zvm_after_init_commands+=(__cfg_after_zvm_init __cfg_enable_paste_quoting)
        '')

        (lib.mkOrder 548 ''
          # Oh-my-zsh lib functions required by the git plugin.
          source ${pkgs.oh-my-zsh}/share/oh-my-zsh/lib/functions.zsh
          source ${pkgs.oh-my-zsh}/share/oh-my-zsh/lib/git.zsh
        '')

        (lib.mkOrder 550 ''
          setopt auto_pushd pushd_ignore_dups pushdminus

          alias -- -='cd -'
          for i in {1..9}; do alias "$i"="cd -$i"; done

          alias md='mkdir -p'

          alias -g ...='../..'
          alias -g ....='../../..'
          alias -g .....='../../../..'
          alias -g ......='../../../../..'

          d() {
            if [[ -n $1 ]]; then
              dirs "$@"
            else
              dirs -v | head -n 10
            fi
          }
          compdef _dirs d
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
