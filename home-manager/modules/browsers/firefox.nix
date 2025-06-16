{ lib, pkgs, config, ... }:

{
  config = {
    programs.firefox = {
      enable = true;
    };
  };
}
