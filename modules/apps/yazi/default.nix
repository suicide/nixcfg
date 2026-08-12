{...}: {
  internal.modules = {
    home.yazi = {
      lib,
      pkgs,
      config,
      ...
    }: {
      config = {
        programs.yazi = {
          enable = true;
          enableZshIntegration = true;
          shellWrapperName = "y";

          plugins = {
            git = {
              package = pkgs.yaziPlugins.git;
              setup = true;
              settings.order = 1500;
            };
            "relative-motions" = pkgs.yaziPlugins.relative-motions;
            "smart-enter" = pkgs.yaziPlugins.smart-enter;
          };

          settings = {
            mgr = {
              show_hidden = true;
              linemode = "size";
            };
            plugin.prepend_fetchers = [
              {
                url = "*";
                run = "git";
                group = "git";
              }
              {
                url = "*/";
                run = "git";
                group = "git";
              }
            ];
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
                  on = ["<Enter>"];
                  run = "plugin smart-enter";
                  desc = "Open file or enter directory";
                }
                {
                  on = ["l"];
                  run = "plugin smart-enter";
                  desc = "Open file or enter directory";
                }
                {
                  on = ["<Right>"];
                  run = "plugin smart-enter";
                  desc = "Open file or enter directory";
                }
                {
                  # we don't need no trash bin
                  run = "remove --permanently";
                  on = ["d"];
                }
              ];
          };

          initLua = ./init.lua;
        };
      };
    };
  };
}
