# TODO screenshots
# TODO screenshare
# TODO minimize
{
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
    __cfg.hyprland.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable hyprland config in homemanager";
    };
  };

  config = {
    home.packages = [
      pkgs.wl-clipboard
    ];

    wayland.windowManager.hyprland = lib.mkIf (cfg.enable) {
      enable = true;

      # start with uwsm
      # https://wiki.hypr.land/Useful-Utilities/Systemd-start/#installation
      systemd.enable = false;

      settings = let
        brightnessctl = lib.getExe pkgs.brightnessctl;
        playerctl = lib.getExe pkgs.playerctl;
        wpctl = lib.getExe' pkgs.wireplumber "wpctl";
      in  {
        monitor = ", preferred, auto, 1.5";

        windowrulev2 = "noborder, onworkspace:w[t1]";

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

          moveworkspace-command = "movetoworkspace";
          moveworkspaces = map (n: "$shiftMod, ${toString n}, ${moveworkspace-command}, ${toWSNumber n}") [1 2 3 4 5 6 7 8 9 0];

          workspace-command = "workspace";
          goworkspaces = map (n: "$mod, ${toString n}, ${workspace-command}, ${toWSNumber n}") [1 2 3 4 5 6 7 8 9 0];
        in
          [
            "$shiftMod, Q, exit,"
            "$shiftMod, C, killactive,"

            "ALT, L, exec, loginctl lock-session"

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
          ]
          ++ goworkspaces
          ++ moveworkspaces;

        bindl = [
          ", XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioPlay, exec, ${playerctl} play-pause"
          ", XF86AudioNext, exec, ${playerctl} next"
          ", XF86AudioPrev, exec, ${playerctl} previous"
        ];

        bindel = [
          ", XF86AudioRaiseVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86MonBrightnessUp, exec, ${brightnessctl} s 5%+"
          ", XF86MonBrightnessDown, exec, ${brightnessctl} s 5%-"
        ];

        input = {
          kb_options = "caps:swapescape";
        };

        gestures = {
          workspace_swipe = true;
        };

        ecosystem = {
          no_update_news = true;
        };
      };
    };
  };
}
