# general home sops config, user secrets are defined in user folder
{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  cfg = config.__cfg.sops;
in {
  options = {
    __cfg.sops.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable SOPS secret management";
    };
  };

  config = {
    sops = lib.mkIf (cfg.enable) {
      age.keyFile = keyFile; # must have no password!
    };
  };
}
