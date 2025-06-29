{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.__cfg.hyprland;
in {
  config = let
    wallpaperPath = ".config/hypr/wallpaper.jpeg";
  in {
    services.hyprpaper = lib.mkIf (cfg.enable) {
      enable = true;
      settings = let
        absoluteWallpaperPath = "${config.home.homeDirectory}/${wallpaperPath}";
      in {
        preload = [absoluteWallpaperPath];
        wallpaper = [", ${absoluteWallpaperPath}"];
      };
    };

    home.file = lib.mkIf (cfg.enable) {
      "${wallpaperPath}".source = ../../../assets/wallpaper/mountain-range.jpeg;
    };
  };
}
