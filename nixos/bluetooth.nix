{
  config,
  pkgs,
  inputs,
  ...
}: {
  config = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
