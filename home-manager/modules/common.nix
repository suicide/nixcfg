{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    home.packages = with pkgs; [
      btop
      htop

      yt-dlp
    ];
  };
}
