{
  lib,
  pkgs,
  config,
  ...
}: let
in {
  config = {
    xdg.mimeApps = {
      enable = true;

      # list all .desktop files
      # ls /run/current-system/sw/share/applications # for global packages
      # ls ~/.nix-profile/share/applications # for home-manager packages
      defaultApplications = {};
    };
  };
}
