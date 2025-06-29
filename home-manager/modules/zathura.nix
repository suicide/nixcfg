{
  lib,
  pkgs,
  config,
  ...
}: let
in {
  config = {
    programs.zathura = {
      enable = true;
    };

    xdg.mimeApps = {
      # list all .desktop files
      # ls /run/current-system/sw/share/applications # for global packages
      # ls ~/.nix-profile/share/applications # for home-manager packages
      defaultApplications = {
        "application/pdf" = "org.pwmt.zathura.desktop";
      };
    };
  };
}
