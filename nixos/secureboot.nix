{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  cfg = config.__cfg.secureboot;
in {
  options = {
    __cfg.secureboot.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable secure boot";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.sbctl
    ];

    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
