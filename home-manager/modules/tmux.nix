{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    programs.tmux = {
      enable = true;
      historyLimit = 1000000;
      keyMode = "vi";
      mouse = true;
      baseIndex = 1;

      terminal = "xterm-kitty";

      # TODO clipboard

      sensibleOnTop = true;

      extraConfig = let
        wl-copy = lib.getExe' pkgs.wl-clipboard "wl-copy";
        wl-paste = lib.getExe' pkgs.wl-clipboard "wl-paste";
        tmux = lib.getExe pkgs.tmux;
      in
        ''
          # tmux must not write to the regular clipboard via OSC 52.
          # Mouse selection in copy-mode should affect only primary selection.
          set -g set-clipboard off

          # Paste primary selection on middle click
          unbind -T root MouseDown2Pane
          bind -T root MouseDown2Pane run-shell "${wl-paste} --primary --no-newline | ${tmux} load-buffer -" \; paste-buffer -p

          # Copy-mode-vi: y / Enter / drag-end copies selected text to primary selection
          bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${wl-copy} --primary"
          bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "${wl-copy} --primary"
          bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "${wl-copy} --primary"
        ''
        # override for macos due to sensible plugin
        # see https://github.com/nix-community/home-manager/issues/5952#issuecomment-2410207554
        + (
          if pkgs.stdenv.isDarwin
          then ''
            set -g default-command ${pkgs.zsh}/bin/zsh
          ''
          else ''
          ''
        );

      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.tokyo-night-tmux;
          extraConfig = ''
            # disable date / time
            set -g @tokyo-night-tmux_show_datetime 0
            # disable git integration due to race condition
            set -g @tokyo-night-tmux_show_git 0
            # show current path
            set -g @tokyo-night-tmux_show_path 1
          '';
        }
        {
          plugin = tmuxPlugins.pain-control;
        }
      ];
    };
  };
}
