{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    programs.git = {
      enable = true;
      lfs = {
        enable = true;
      };
      signing = {
        signByDefault = true;
      };

      extraConfig = {
        commit.verbose = true;
        tag = {
          gpgSign = false;
          sort = "version:refname";
        };
        diff = {
          algorithm = "histogram";
          colorMoved = "plain";
          mnemonicPrefix = true;
          renames = true;
        };
        push = {
          autoSetupRemote = true;
          recurseSubmodules = "on-demand";
        };
        fetch = {
          prune = true;
          pruneTags = true;
          all = true;
        };
        rerere = {
          enabled = true;
          autoupdate = true;
        };
        merge.conflictstyle = "zdiff3";
        rebase = {
          autoSquash = true;
          autoStash = true;
        };
        submodule.recurse = true;
      };
    };

    home.packages = with pkgs; [
      git-secret
    ];
  };
}
