# TODO screenshare
# TODO minimize
{ inputs
, lib
, pkgs
, config
, ...
}:
let
  cfg = config.__cfg.hyprland;
  lua = lib.generators.mkLuaInline;

  toWorkspaceKey = n:
    if n == 0
    then "0"
    else toString n;

  toWorkspaceNumber = n:
    if n == 0
    then 10
    else n;

  parseScale = value:
    if builtins.match "^[0-9]+(\\.[0-9]+)?$" value != null
    then builtins.fromJSON value
    else value;

  parseMonitor = raw:
    let
      parts = map lib.strings.trim (lib.splitString "," raw);
    in
    {
      output = lib.elemAt parts 0;
      mode = lib.elemAt parts 1;
      position = lib.elemAt parts 2;
      scale = parseScale (lib.elemAt parts 3);
    }
    // lib.optionalAttrs (builtins.length parts > 5 && lib.elemAt parts 4 == "mirror") {
      mirror = lib.elemAt parts 5;
    };

  mkBind = key: action: {
    _args = [ key action ];
  };

  mkBindWithOptions = key: action: options: {
    _args = [ key action options ];
  };

  mkHyprctlDispatchBind = key: dispatcher: argument:
    mkBind key (lua ''hl.dsp.exec_cmd("hyprctl dispatch ${dispatcher}${if argument == "" then "" else " " + argument}")'');

  mkExecBind = key: command:
    mkBind key (lua "hl.dsp.exec_cmd(${builtins.toJSON command})");

  mkPluginBind = key: action: arg:
    mkBind key (lua "function() return smw.${action}(${arg}) end");

  mkFocusBind = key: direction:
    mkBind key (lua ''hl.dsp.focus({ direction = "${direction}" })'');

  mkMoveBind = key: direction:
    mkBind key (lua ''hl.dsp.window.move({ direction = "${direction}" })'');
in
{
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
        default = [ ];
        description = "Commands to run on hyprland startup";
      };
      swapEsc = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Swap Caps Lock and Escape keys";
      };
      displayWorkspaces = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable handling workspaces per display";
      };
      monitors = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
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
      configType = "lua";
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

      plugins = lib.optionals cfg.displayWorkspaces [
        inputs.hyprland-split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
      ];

      # start with uwsm
      # https://wiki.hypr.land/Useful-Utilities/Systemd-start/#installation
      systemd.enable = false;

      settings =
        let
          brightnessctl = lib.getExe pkgs.brightnessctl;
          playerctl = lib.getExe pkgs.playerctl;
          wpctl = lib.getExe' pkgs.wireplumber "wpctl";
          dunstctl = lib.getExe' pkgs.dunst "dunstctl";
          hyprshot = lib.getExe pkgs.hyprshot;
          monitors = map parseMonitor cfg.monitors;
          standardWorkspaceBinds = map
            (n:
              mkBind
                (lua ''mod .. " + ${toWorkspaceKey n}"'')
                (
                  if cfg.displayWorkspaces
                  then lua "function() return smw.workspace(${toString (toWorkspaceNumber n)}) end"
                  else lua "hl.dsp.focus({ workspace = ${toString (toWorkspaceNumber n)} })"
                )) [ 1 2 3 4 5 6 7 8 9 0 ];
          moveWorkspaceBinds = map
            (n:
              mkBind
                (lua ''shiftMod .. " + ${toWorkspaceKey n}"'')
                (
                  if cfg.displayWorkspaces
                  then lua "function() return smw.move_to_workspace(${toString (toWorkspaceNumber n)}) end"
                  else lua ''hl.dsp.window.move({ workspace = "${toString (toWorkspaceNumber n)}" })''
                )) [ 1 2 3 4 5 6 7 8 9 0 ];
        in
        {
          mod = {
            _var = "SUPER";
          };

          shiftMod = {
            _var = "SUPER + SHIFT";
          };

          smw = lib.mkIf cfg.displayWorkspaces {
            _var = lua "hl.plugin.split_monitor_workspaces";
          };

          monitor = monitors;

          window_rule = {
            match.workspace = "w[tv1]";
            border_size = 0;
          };

          config = {
            general = {
              gaps_out = {
                top = 5;
                right = 0;
                bottom = 0;
                left = 0;
              };
            };
            ecosystem = {
              no_update_news = true;
            };
            misc = {
              vrr = 1;
            };
          }
          // lib.optionalAttrs cfg.swapEsc {
            input = {
              kb_options = "caps:swapescape";
            };
          }
          // lib.optionalAttrs cfg.displayWorkspaces {
            plugin.split_monitor_workspaces = {
              # disabled, otherwise waybar shows all predefined workspaces even if empty
              enable_persistent_workspaces = 0;
            };
          };

          gesture = {
            fingers = 3;
            direction = "horizontal";
            action = "workspace";
          };

          on = lib.optional (cfg.onStartup != [ ]) {
            _args = [
              "hyprland.start"
              (lua ''function()
              ${lib.concatMapStrings (command: "hl.exec_cmd(${builtins.toJSON command})\n  ") cfg.onStartup}end'')
            ];
          };

          bind =
            [
              (mkBind (lua ''shiftMod .. " + Q"'') (lua "hl.dsp.exit()"))
              (mkBind (lua ''shiftMod .. " + C"'') (lua "hl.dsp.window.close()"))
              (mkExecBind "CTRL + ALT + L" "loginctl lock-session")
              (mkBind (lua ''shiftMod .. " + F"'') (lua ''hl.dsp.window.float({ action = "toggle" })''))
              (mkBind (lua ''mod .. " + T"'') (lua ''hl.dsp.window.pin({ action = "toggle" })''))
              (mkBind (lua ''mod .. " + F"'') (lua "hl.dsp.window.fullscreen()"))
              (mkFocusBind (lua ''mod .. " + h"'') "left")
              (mkFocusBind (lua ''mod .. " + l"'') "right")
              (mkFocusBind (lua ''mod .. " + k"'') "up")
              (mkFocusBind (lua ''mod .. " + j"'') "down")
              (mkMoveBind (lua ''shiftMod .. " + h"'') "left")
              (mkMoveBind (lua ''shiftMod .. " + l"'') "right")
              (mkMoveBind (lua ''shiftMod .. " + k"'') "up")
              (mkMoveBind (lua ''shiftMod .. " + j"'') "down")
              (mkExecBind (lua ''mod .. " + RETURN"'') "kitty")
              (mkExecBind (lua ''mod .. " + D"'') "rofi -show drun -show-icons")
              (mkExecBind (lua ''mod .. " + Q"'') "brave")
              (mkExecBind (lua ''mod .. " + E"'') "brave --incognito")
              (mkExecBind (lua ''shiftMod .. " + E"'') "brave --tor")
              (mkExecBind (lua ''mod .. " + ALT + E"'') "librewolf")
              (mkExecBind (lua ''shiftMod .. " + ALT + E"'') "librewolf --private-window")
              (mkExecBind (lua ''mod .. " + Delete"'') "${dunstctl} close-all")
              (mkExecBind "PRINT" "${hyprshot} -m active -m output")
              (mkExecBind (lua ''mod .. " + PRINT"'') "${hyprshot} -m active -m window")
              (mkExecBind (lua ''shiftMod .. " + PRINT"'') "${hyprshot} -m region")
              (mkBindWithOptions (lua ''mod .. " + mouse:272"'') (lua "hl.dsp.window.drag()") { mouse = true; })
              (mkBindWithOptions (lua ''mod .. " + mouse:273"'') (lua "hl.dsp.window.resize()") { mouse = true; })
              (mkBindWithOptions "XF86AudioMute" (lua "hl.dsp.exec_cmd(${builtins.toJSON "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"})") { locked = true; })
              (mkBindWithOptions "XF86AudioPlay" (lua "hl.dsp.exec_cmd(${builtins.toJSON "${playerctl} play-pause"})") { locked = true; })
              (mkBindWithOptions "XF86AudioNext" (lua "hl.dsp.exec_cmd(${builtins.toJSON "${playerctl} next"})") { locked = true; })
              (mkBindWithOptions "XF86AudioPrev" (lua "hl.dsp.exec_cmd(${builtins.toJSON "${playerctl} previous"})") { locked = true; })
              (mkBindWithOptions "XF86AudioRaiseVolume" (lua "hl.dsp.exec_cmd(${builtins.toJSON "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+"})") { locked = true; repeating = true; })
              (mkBindWithOptions "XF86AudioLowerVolume" (lua "hl.dsp.exec_cmd(${builtins.toJSON "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-"})") { locked = true; repeating = true; })
              (mkBindWithOptions "XF86MonBrightnessUp" (lua "hl.dsp.exec_cmd(${builtins.toJSON "${brightnessctl} s 5%+"})") { locked = true; repeating = true; })
              (mkBindWithOptions "XF86MonBrightnessDown" (lua "hl.dsp.exec_cmd(${builtins.toJSON "${brightnessctl} s 5%-"})") { locked = true; repeating = true; })
            ]
            ++ standardWorkspaceBinds
            ++ moveWorkspaceBinds
            ++ lib.optionals cfg.displayWorkspaces [
              (mkPluginBind (lua ''mod .. " + O"'') "change_monitor" ''"next"'')
            ];
        };
    };
  };
}
