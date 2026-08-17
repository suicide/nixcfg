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
            # Re-add pkgs.yaziPlugins.git (and prepend_fetchers) once nixpkgs
            # is newer than 0-unstable-2026-08-12; older fetch() never completes
            # and blocks quit with "Run fetcher 'git' with N target(s)".
            "relative-motions" = pkgs.yaziPlugins.relative-motions;
            "smart-enter" = pkgs.yaziPlugins.smart-enter;
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
