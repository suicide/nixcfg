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

      # TODO clipboard

      sensibleOnTop = true;

      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.tokyo-night-tmux;
          extraConfig = ''
            # disable date / time
            set -g @tokyo-night-tmux_show_datetime 0
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
