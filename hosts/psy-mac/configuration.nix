{ config, pkgs, inputs, ... }:

{
  imports =
    [
      # inputs.sops-nix.nixosModules.sops

      # ../../nixos/base.nix
      ../../nixos/nix.nix
      # ../../nixos/gc.nix

      ../../darwin/appearance.nix
      ../../darwin/finder.nix

      inputs.home-manager.darwinModules.home-manager
      ../../darwin/home-manager.nix
      # ../../nixos/users.nix
    ];

  config = {
    system.primaryUser = "psy";

    users.users.psy = {
      name = "psy";
      home = "/Users/psy";
      shell = pkgs.zsh;
    };


    system.stateVersion = 6;
  };

}

