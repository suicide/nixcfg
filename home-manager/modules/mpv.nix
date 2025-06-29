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
    };

    home.packages = with pkgs; [
    ];
  };
}
