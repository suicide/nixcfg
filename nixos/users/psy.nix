{ config, pkgs, inputs, ... }:

{
  config = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.psy = {
      isNormalUser = true;
      description = "psy";
      initialPassword = "testtest";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
      ];
      shell = pkgs.zsh;
    };

    home-manager.users.psy = {
      imports = [
        ../../home-manager/home.nix
      ];
    };

  };
}
