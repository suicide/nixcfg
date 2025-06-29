{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.__cfg.hyprland;
in {
  config = {
    programs.hyprlock = lib.mkIf (cfg.enable) {
      enable = true;
    };
  };
}
