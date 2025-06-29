{
  lib,
  pkgs,
  config,
  ...
}: let
in {
  config = {
    programs.feh = {
      enable = true;
    };

    xdg.mimeApps = {
      # list all .desktop files
      # ls /run/current-system/sw/share/applications # for global packages
      # ls ~/.nix-profile/share/applications # for home-manager packages
      defaultApplications = let
        feh = "feh.desktop";
        types = ["image/png" "image/jpeg" "image/gif" "image/webp" "image/bmp"];
      in
        lib.genAttrs types (t: feh);
    };
  };
}
