{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    programs.mpv = {
      enable = true;

      config = {
        volume-max = 300;
      };

      scripts = [
        pkgs.mpvScripts.mpris # integration with playerctld
      ];
    };

    home.packages = with pkgs; [
    ];
  };
}
