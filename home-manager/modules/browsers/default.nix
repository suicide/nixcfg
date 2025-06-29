{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./brave.nix
    ./chromium.nix
    ./firefox.nix
    ./librewolf.nix
  ];

  config = {};
}
