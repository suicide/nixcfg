{
  lib,
  pkgs,
  config,
  ...
}: let
  cfgHyprland = config.__cfg.hyprland;
  cfg = config.__cfg.hypridle;

  # Runtime keep-awake toggle. The user service below is the on/off state;
  # hypridle's suspend listener calls `keep-awake suspend`, which becomes a
  # no-op while the service is active. Display blanking and locking are not
  # affected, and lid/power-key actions still work because only the idle
  # suspend path is gated.
  keepAwake = pkgs.writeShellApplication {
    name = "keep-awake";
    runtimeInputs = [
      pkgs.dunst
      pkgs.procps
      pkgs.systemd
    ];
    text = ''
      unit="keep-awake.service"

      is_active() {
        systemctl --user is-active --quiet "$unit"
      }

      notify() {
        dunstify -a keep-awake -u low -r 4242 "$1" >/dev/null 2>&1 || true
      }

      refresh_waybar() {
        pkill -RTMIN+8 waybar 2>/dev/null || true
      }

      case "''${1:-status}" in
        service)
          # State marker only; RemainAfterExit keeps the unit active.
          :
          ;;
        suspend)
          if is_active; then
            exit 0
          fi
          exec systemctl suspend-then-hibernate
          ;;
        toggle)
          if is_active; then
            systemctl --user stop "$unit"
            notify "Keep awake: OFF"
          else
            systemctl --user start "$unit"
            notify "Keep awake: ON"
          fi
          refresh_waybar
          ;;
        status)
          if is_active; then
            printf '{"text":"<span color=\x27#FFD700\x27> 󰒳 </span>","tooltip":"keep awake: on","class":"on"}\n'
          else
            printf '{"text":"<span color=\x27#696969\x27> 󰒳 </span>","tooltip":"keep awake: off","class":"off"}\n'
          fi
          ;;
        *)
          echo "usage: keep-awake [service|suspend|toggle|status]" >&2
          exit 2
          ;;
      esac
    '';
  };
in {
  options = {
    __cfg.hypridle.keyboardBacklight = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "framework_laptop::kbd_backlight";
      description = "Keyboard backlight brightness control in brightnessctl";
    };
  };

  config = lib.mkIf cfgHyprland.enable {
    home.packages = [keepAwake];

    systemd.user.services.keep-awake = {
      Unit = {
        Description = "Keep the system awake (block idle auto-suspend)";
      };

      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${keepAwake}/bin/keep-awake service";
      };
    };

    services.hypridle = {
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
          after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'";

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
              on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = \"disable\" })'";
              on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })' && ${brightnessctl} -r";
            }
            {
              timeout = 1800;
              on-timeout = "${keepAwake}/bin/keep-awake suspend";
            }
          ];
      };
    };
  };
}
