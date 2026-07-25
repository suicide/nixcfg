{
  inputs,
  lib,
  ...
}: let
  options = {
    __cfg.sops.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable SOPS secrets";
    };
  };
in {
  internal.modules = {
    nixos.sops = {
      imports = [inputs.sops-nix.nixosModules.sops];
      inherit options;
    };

    darwin.sops = {
      imports = [inputs.sops-nix.darwinModules.sops];
      inherit options;
    };
  };
}
