{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./brave.nix
    ./chromium.nix
    ./firefox
    ./librewolf
  ];

  config = {};
}
