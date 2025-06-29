{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.__cfg.hyprland;
in {
  config = {
    home = lib.mkIf (cfg.enable) {
      pointerCursor = {
        package = pkgs.simp1e-cursors;
        name = "Simp1e-Tokyo-Night";
        size = 28;
        gtk.enable = true;
        x11.enable = true;
        hyprcursor.enable = true;
      };
    };
  };
}
