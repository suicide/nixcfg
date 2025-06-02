{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./sops.nix
  ];

  home = {
    username = "psy";
    homeDirectory = "/home/psy";
  };
}


