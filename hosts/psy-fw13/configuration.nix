# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series

      inputs.disko.nixosModules.default
      # ./disk-config.nix

      inputs.sops-nix.nixosModules.sops

      ../../nixos/impermanence

      ../../nixos/base.nix
      ../../nixos/gc.nix

      ../../nixos/audio.nix
      ../../nixos/firewall.nix
      ../../nixos/wifi.nix
      ../../nixos/xserver.nix

      inputs.home-manager.nixosModules.home-manager
      ../../nixos/home-manager.nix
      ../../nixos/users/psy.nix
    ];

  config = {

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    __cfg.impermanence.disko = {
      device = "/dev/nvme0n1";
      swapSize = "100G";
    };

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "psy-fw13"; # Define your hostname.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Set your time zone.
    time.timeZone = "Europe/Berlin";


    # framework hardware
    services.fwupd.enable = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.05"; # Did you read the comment?
  };

}
