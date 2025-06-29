{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options = {
    __cfg.sops.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable sops secrets in nixos";
    };
  };

  config = {
  };
}
