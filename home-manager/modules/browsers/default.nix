{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./chromium.nix
    ./firefox
    ./librewolf
  ];

  config = {};
}
