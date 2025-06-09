{ config, pkgs, inputs, lib, hostname, ... }:
let
  cfg = config.__cfg;
in 

{
  options = {
    __cfg.mainUser = lib.mkOption {
      type = lib.types.str;
      default = "psy";
      description = "Main user to provision"
    };
  };

  config = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${cfg.mainUser} = {
      isNormalUser = true;
      description = "${cfg.mainUser}";
      initialPassword = "testtest";
      extraGroups = [ "networkmanager" "wheel" ];
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

