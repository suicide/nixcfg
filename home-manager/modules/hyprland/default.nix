# TODO screenshare
# TODO minimize
{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.__cfg.hyprland;
in {
  imports = [
    ./cursor.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprpaper.nix
  ];

  options = {
    __cfg.hyprland = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable hyprland config in homemanager";
      };
      onStartup = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Commands to run on hyprland startup";
      };
      swapEsc = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Swap Caps Lock and Escape keys";
      };
      monitors = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Display settings";
      };
    };
  };

  config = {
    home.packages = [
      pkgs.wl-clipboard
    ];

    wayland.windowManager.hyprland = lib.mkIf cfg.enable {
      enable = true;

      plugins = [
        inputs.hyprland-split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
      ];

      # start with uwsm
      # https://wiki.hypr.land/Useful-Utilities/Systemd-start/#installation
      systemd.enable = false;

      settings = let
        brightnessctl = lib.getExe pkgs.brightnessctl;
        playerctl = lib.getExe pkgs.playerctl;
        wpctl = lib.getExe' pkgs.wireplumber "wpctl";
        dunstctl = lib.getExe' pkgs.dunst "dunstctl";
        hyprshot = lib.getExe pkgs.hyprshot;
      in {
        monitor = cfg.monitors;

        windowrulev2 = "noborder, onworkspace:w[t1]";

        exec-once = cfg.onStartup;

        general = {
          gaps_out = "5,0,0,0";
        };

        "$mod" = "SUPER";
        "$shiftMod" = "SHIFT_SUPER";

        bind = let
          toWSNumber = n: (toString (
            if n == 0
            then 10
            else n
          ));

          moveworkspace-command = "split-movetoworkspace";
          moveworkspaces = map (n: "$shiftMod, ${toString n}, ${moveworkspace-command}, ${toWSNumber n}") [1 2 3 4 5 6 7 8 9 0];

          workspace-command = "split-workspace";
          goworkspaces = map (n: "$mod, ${toString n}, ${workspace-command}, ${toWSNumber n}") [1 2 3 4 5 6 7 8 9 0];
        in
          [
            "$shiftMod, Q, exit,"
            "$shiftMod, C, killactive,"

            "CTRL ALT, L, exec, loginctl lock-session"

            "$mod CTRL, Space, togglefloating,"
            "$mod, F, fullscreen,"
            "$mod, T, pin,"

            "$mod, h, movefocus, l"
            "$mod, l, movefocus, r"
            "$mod, k, movefocus, u"
            "$mod, j, movefocus, d"

            "$shiftMod, h, movewindow, l"
            "$shiftMod, l, movewindow, r"
            "$shiftMod, k, movewindow, u"
            "$shiftMod, j, movewindow, d"

            "$mod, Return, exec, kitty"
            "$mod, D, exec, rofi -show drun -show-icons"

            "$mod, Q, exec, brave"
            "$mod, E, exec, brave --incognito"
            "$shiftMod, E, exec, brave --tor"
            "$mod ALT, E, exec, librewolf"
            "$shiftMod ALT, E, exec, librewolf --private-window"

            # Dismisses ALL currently displayed notifications via dunstctl
            "$mod, Delete, exec, ${dunstctl} close-all"

            # screenshot
            ", PRINT, exec, ${hyprshot} -m active -m output"
            "$mod, PRINT, exec, ${hyprshot} -m active -m window"
            "$shiftMod, PRINT, exec, ${hyprshot} -m region"

            # Media keys
            # ", XF86Display, exec, ${playerctl} previous"
            # ", XF86RFKill, exec, ${playerctl} previous"
            # ", XF86Print, exec, ${playerctl} previous"
            # ", XF86AudioMedia, exec, ${playerctl} previous"
          ]
          ++ goworkspaces
          ++ moveworkspaces;

        bindl = [
          # Media keys
          ", XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioPlay, exec, ${playerctl} play-pause"
          ", XF86AudioNext, exec, ${playerctl} next"
          ", XF86AudioPrev, exec, ${playerctl} previous"
        ];

        bindel = [
          # Media keys
          ", XF86AudioRaiseVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86MonBrightnessUp, exec, ${brightnessctl} s 5%+"
          ", XF86MonBrightnessDown, exec, ${brightnessctl} s 5%-"
        ];

        input = lib.mkIf cfg.swapEsc {
          kb_options = "caps:swapescape";
        };

        gesture = [
          "3, horizontal, workspace,"
        ];

        ecosystem = {
          no_update_news = true;
        };

        plugin = {
          split-monitor-workspaces = {
            # disabled, otherwise waybar all predefined workspaces even if empty
            enable_persistent_workspaces = 0;
          };
        };
      };
    };
  };
}
