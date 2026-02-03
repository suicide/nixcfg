{
  config,
  pkgs,
  inputs,
  lib,
  hostname,
  ...
}: let
  cfg = config.__cfg;
in {
  options = {
    __cfg.mainUser = lib.mkOption {
      type = lib.types.str;
      default = "psy";
      description = "Main user to provision";
    };
  };

  config = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${cfg.mainUser} = {
      isNormalUser = true;
      uid = 1000;
      description = "${cfg.mainUser}";
      hashedPassword = "$6$Y147CW7B3CWybgq7$VDfH7eOp4YaYLAP6QWAX.KEZ2YYwzoFkzvOLpzMUifFZBwluIBtmjdf7hHLBbyRsg.c6WT5qMTTITit2pc2Xt/";
      extraGroups = ["networkmanager" "wheel"];
      packages = with pkgs; [
      ];
      shell = pkgs.zsh;
    };

    home-manager.users.${cfg.mainUser} = {
      imports = [
        ../home-manager/home.nix
        ../home-manager/users/${cfg.mainUser}
        ../hosts/${hostname}/home.nix
      ];
    };
  };
}
