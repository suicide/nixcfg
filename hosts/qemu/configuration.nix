# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  hostname,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    inputs.disko.nixosModules.default
    # ./disk-config.nix

    inputs.sops-nix.nixosModules.sops

    ../../nixos/impermanence
    ../../nixos/impermanence/users/psy.nix

    ../../nixos/base.nix
    ../../nixos/linux-base.nix
    ../../nixos/boot.nix
    ../../nixos/gc.nix
    ../../nixos/nix.nix

    ../../nixos/firewall.nix
    ../../nixos/xserver.nix

    inputs.home-manager.nixosModules.home-manager
    ../../nixos/home-manager.nix
    ../../nixos/users.nix
  ];

  config = {
    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = hostname; # Define your hostname.

    __cfg.mainUser = "psy";

    services.xserver.desktopManager.gnome.enable = true;

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Set your time zone.
    time.timeZone = "Europe/Berlin";

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.05"; # Did you read the comment?
  };
}
