{ config, pkgs, inputs, ... }:

{
  nix = {
    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };

    optimise.automatic = true;
  };

  boot.loader.systemd-boot.configurationLimit = 10;
}

