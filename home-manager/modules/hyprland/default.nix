{ lib, pkgs, config, ... }:
let
  cfg = config.__cfg.hyprland;
in 

{
  options = {
    __cfg.hyprland.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable hyprland config in homemanager";
    };
  };

  config = {
    wayland.windowManager.hyprland = lib.mkIf (cfg.enable) {
      enable = true;
      settings = {
        "$mod" = "SUPER";
        "$shiftMod" = "SHIFT_SUPER";
        bind = [
          "$shiftMod, Q, exit,"
          "$shiftMod, C, killactive,"

          "$mod, Return, exec, kitty"
          "$mod, Q, exec, brave"
        ];
        input = {
          kb_options = "caps:swapescape";
        };
      };
    };
  };
}
