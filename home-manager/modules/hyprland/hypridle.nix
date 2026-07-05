{
  lib,
  pkgs,
  config,
  ...
}: let
  cfgHyprland = config.__cfg.hyprland;
  cfg = config.__cfg.hypridle;
in {
  options = {
    __cfg.hypridle.keyboardBacklight = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "framework_laptop::kbd_backlight";
      description = "Keyboard backlight brightness control in brightnessctl";
    };
  };

  config = {
    services.hypridle = lib.mkIf (cfgHyprland.enable) {
      enable = true;

      settings = let
        brightnessctl = lib.getExe pkgs.brightnessctl;
        cliphist = lib.getExe pkgs.cliphist;
        wl-copy = lib.getExe' pkgs.wl-clipboard "wl-copy";
        keyboardBrightness =
          if cfg.keyboardBacklight != null
          then [
            {
              # keyboard
              timeout = 150;
              on-timeout = "${brightnessctl} -sd ${cfg.keyboardBacklight} set 0";
              on-resume = "${brightnessctl} -rd ${cfg.keyboardBacklight}";
            }
          ]
          else [];
      in {
        general = {
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";

          # Wipe clipboard state before locking to avoid secrets persisting
          # across lock/unlock. cliphist DB is in $XDG_RUNTIME_DIR and also
          # disappears on logout.
          lock_cmd = "${cliphist} -db-path \"$XDG_RUNTIME_DIR/cliphist/db\" wipe; ${wl-copy} --clear; ${wl-copy} --primary --clear; pidof hyprlock || hyprlock";
        };

        listener =
          keyboardBrightness
          ++ [
            {
              # monitor
              timeout = 150;
              on-timeout = "${brightnessctl} -s set 10";
              on-resume = "${brightnessctl} -r";
            }
            {
              timeout = 600;
              on-timeout = "loginctl lock-session";
            }
            {
              timeout = 900;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on && ${brightnessctl} -r";
            }
            {
              timeout = 1800;
              on-timeout = "systemctl suspend-then-hibernate";
            }
          ];
      };
    };
  };
}
