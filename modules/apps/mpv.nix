{...}: {
  internal.modules = {
    home.mpv = {
      lib,
      pkgs,
      config,
      ...
    }: {
      config = {
        programs.mpv = let
          linuxPlugins = [
            pkgs.mpvScripts.mpris # integration with playerctld
          ];
        in {
          enable = true;

          config = {
            volume-max = 300;

            # temporary workaround for https://github.com/mpv-player/mpv/issues/17170
            # target-colorspace-hint = "no";
          };

          profiles = {
            # temporary workaround for https://github.com/mpv-player/mpv/issues/17170
            libplacebo-workaround = {
              profile-cond = "p['current-vo'] == 'gpu-next' and p['video-params/gamma'] == 'bt.1886'";
              profile-restore = "copy";
              target-trc = "bt.1886";
            };

            # mpv 0.42 pseudo-gui sets idle=yes, so the window stays open after
            # playback. Restore the previous quit-on-end behavior for GUI launches.
            # https://github.com/mpv-player/mpv/commit/c0c758434211649e4abe81d571c329fff8c7123f
            quit-when-finished = {
              profile-cond = "p['player-operation-mode'] == 'pseudo-gui'";
              idle = "once";
            };
          };

          scripts =
            []
            ++ (
              if !pkgs.stdenv.hostPlatform.isDarwin
              then linuxPlugins
              else []
            );
        };
      };
    };
  };
}
