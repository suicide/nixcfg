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
        target-colorspace-hint = "no";
      };

      scripts = [
      ]
      ++ (if !pkgs.stdenv.isDarwin then linuxPlugins else []);
    };

    home.packages = with pkgs; [
    ];
  };
}
