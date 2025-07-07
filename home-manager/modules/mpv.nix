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
      };

      scripts = [
      ]
      ++ (if !pkgs.stdenv.isDarwin then linuxPlugins else []);
    };

    home.packages = with pkgs; [
    ];
  };
}
