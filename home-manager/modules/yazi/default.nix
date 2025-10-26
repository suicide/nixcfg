{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;

      plugins = {
        "relative-motions" = pkgs.yaziPlugins.relative-motions;
      };

      settings = {
        mgr = {
          show_hidden = true;
          linemode = "size";
        };
      };
      keymap = {
        mgr.prepend_keymap =
          (let
            numKeys = [1 2 3 4 5 6 7 8 9];
            asMotion = n: {
              on = ["${toString n}"];
              run = "plugin relative-motions ${toString n}";
              desc = "Move in relative steps";
            };
          in
            map asMotion numKeys)
          ++ [
            {
              # we don't need no trash bin
              run = "remove --permanently";
              on = ["d"];
            }
          ];
      };

      initLua = ./init.lua;
    };

    home.packages = with pkgs; [
    ];
  };
}
