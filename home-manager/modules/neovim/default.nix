{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./neovim.nix
    ./mcphub.nix
  ];
}
