{pkgs, lib, config, ...}: let

in
{
  imports = [
    ./base.nix
    ./users/psy.nix
  ];
}

