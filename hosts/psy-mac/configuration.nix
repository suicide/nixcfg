{ config, pkgs, inputs, ... }:

{
  imports =
    [
      # inputs.sops-nix.nixosModules.sops

      # ../../nixos/base.nix
      # ../../nixos/gc.nix

      # inputs.home-manager.nixosModules.home-manager
      # ../../nixos/home-manager.nix
      # ../../nixos/users.nix
    ];

  config = {

    nix.settings.experimental-features = [ "nix-command" "flakes"];

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    system.primaryUser = "psy";

    system.defaults.finder.AppleShowAllExtensions = true;
    system.defaults.dock.autohide = true;



    system.stateVersion = 6;
  };

}

