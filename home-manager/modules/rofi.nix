{
  lib,
  pkgs,
  config,
  ...
}: let
  rofiTheme = pkgs.fetchFromGitHub {
    owner = "newmanls";
    repo = "rofi-themes-collection";
    rev = "ec731cef79d39fc7ae12ef2a70a2a0dd384f9730";
    hash = "sha256-96wSyOp++1nXomnl8rbX5vMzaqRhTi/N7FUq6y0ukS8=";
  };
in {
  config = {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      terminal = "${lib.getExe pkgs.kitty}";
      theme = rofiTheme + "/themes/squared-nord.rasi";
    };
  };
}
