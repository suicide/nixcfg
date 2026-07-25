{
  lib,
  inputs,
  ...
}: let
  options = {
    __cfg.secureboot.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable secure boot using Lanzaboote. Requires sbctl setup.";
    };
  };
in {
  internal.modules = {
    nixos.secureboot = {
      config,
      pkgs,
      ...
    }: {
      imports = [inputs.lanzaboote.nixosModules.lanzaboote];
      inherit options;
      config = lib.mkIf config.__cfg.secureboot.enable {
        environment.systemPackages = [pkgs.sbctl];
        boot.loader.systemd-boot.enable = lib.mkForce false;
        boot.lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
        };
      };
    };
  };
}
