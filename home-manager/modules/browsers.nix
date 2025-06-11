{ lib, pkgs, config, ... }:

{
  config = {
    programs.brave = {
      enable = true;
    };

    programs.chromium = {
      enable = true;
    };

    programs.firefox = {
      enable = true;
    };

    programs.librewolf = {
      enable = true;
    };
  };
}
