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
        in  [
          "$shiftMod, Q, exit,"
          "$shiftMod, C, killactive,"

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
          "$mod, Q, exec, brave"
          "$mod, E, exec, brave --incognito"
        ]
        ++ goworkspaces
        ++ moveworkspaces;

        bindl = [
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ];

        bindel = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ];

        input = {
          kb_options = "caps:swapescape";
        };
      };
    };
  };
}
