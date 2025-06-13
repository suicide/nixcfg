{ config, pkgs, inputs, ... }:

{
  imports =
    [
      # inputs.sops-nix.nixosModules.sops

      # ../../nixos/base.nix
      ../../nixos/nix.nix
      ../../nixos/gc.nix

      ../../darwin/appearance.nix
      ../../darwin/finder.nix

      # inputs.home-manager.nixosModules.home-manager
      # ../../nixos/home-manager.nix
      # ../../nixos/users.nix
    ];

  config = {
    system.primaryUser = "psy";


    system.stateVersion = 6;
  };

}

