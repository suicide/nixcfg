{
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
      };

      scripts =
        []
        ++ (
          if !pkgs.stdenv.isDarwin
          then linuxPlugins
          else []
        );
    };

    home.packages = with pkgs; [
    ];
  };
}
