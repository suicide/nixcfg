# general home sops config, user secrets are defined in user folder
{ lib, pkgs, config, inputs, ... }:
let
  keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
in
{
  config = {
    sops = lib.mkIf (inputs.enableSecrets.value) {
      age.keyFile = keyFile; # must have no password!
    };
  };
}
