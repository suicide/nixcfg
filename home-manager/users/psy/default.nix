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

    ./opencode.nix
  ];

  home = {
    username = "psy";
    homeDirectory = "/home/psy";
  };
}
