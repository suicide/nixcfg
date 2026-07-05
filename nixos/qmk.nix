{
  config,
  pkgs,
  inputs,
  ...
}: let
in {
  config = {
    hardware.keyboard.qmk.enable = true;
  };
}
