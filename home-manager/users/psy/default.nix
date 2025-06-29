{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./sops.nix
    ./ssh.nix
  ];

  home = {
    username = "psy";
    homeDirectory = "/home/psy";
  };
}
