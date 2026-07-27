{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  cfg = config.__cfg.sops;
in {
  config = {
    sops = lib.mkIf cfg.enable {
      defaultSopsFile = ../../../secrets/hosts/psy-fw13.yaml;
      age.keyFile = "/persist/home/psy/.config/sops/age/keys.txt";

      secrets."wireguard/homenet2/configFile" = {};
      secrets."samba/luna/credentials" = {};
    };
  };
}
