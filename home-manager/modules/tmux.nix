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

      # TODO clipboard

      sensibleOnTop = true;

      extraConfig = ''
      ''
      # override for macos due to sensible plugin
      # see https://github.com/nix-community/home-manager/issues/5952#issuecomment-2410207554
      + (if pkgs.stdenv.isDarwin then ''
        set -g default-command ${pkgs.zsh}/bin/zsh
      '' else ''
      '');

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
