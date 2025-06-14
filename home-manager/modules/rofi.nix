{ lib, pkgs, config, ... }:
let
  
  # rofiTheme = pkgs.fetchFromGitHub {
  #       owner = "newmanls";
  #       repo = "rofi-themes-collection";
  #       rev = "ec731cef79d39fc7ae12ef2a70a2a0dd384f9730";
  #       hash = "";
  #     };
in 

{
  config = {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      terminal = "${lib.getExe pkgs.kitty}";
    };
  };
}

