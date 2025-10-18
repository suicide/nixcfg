{
  lib,
  pkgs,
  config,
  ...
}: let
  hyprlandCfg = config.__cfg.hyprland;
in {
  config = {
    home.pointerCursor = lib.mkIf (!hyprlandCfg.enable) {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };

    gtk = {
      enable = true;

      theme = {
        package = pkgs.flat-remix-gtk;
        name = "Flat-Remix-GTK-Grey-Dark";
      };

      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };

      font = {
        name = "Sans";
        size = 10;
      };
    };
  };
}
