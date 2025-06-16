{ lib, pkgs, config, ... }:

{
  config = {
    programs.librewolf = {
      enable = true;
    };
  };
}
