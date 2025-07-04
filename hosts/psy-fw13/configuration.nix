{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series

    inputs.disko.nixosModules.default
    # ./disk-config.nix

    inputs.lanzaboote.nixosModules.lanzaboote
    ../../nixos/secureboot.nix

    inputs.sops-nix.nixosModules.sops
    ../../nixos/sops.nix
    ./sops.nix

    ../../nixos/impermanence
    ../../nixos/impermanence/users/psy.nix

    ../../nixos/base.nix
    ../../nixos/linux-base.nix
    ../../nixos/boot.nix
    ../../nixos/gc.nix
    ../../nixos/nix.nix

    ../../nixos/powermanagement.nix
    ../../nixos/laptop.nix

    ../../nixos/audio.nix
    ../../nixos/bluetooth.nix
    ../../nixos/firewall.nix
    ../../nixos/wifi.nix
    ../../nixos/xserver.nix

    ../../nixos/network/shares.nix

    inputs.home-manager.nixosModules.home-manager
    ../../nixos/home-manager.nix
    ../../nixos/users.nix
  ];

  config = {
    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    __cfg.impermanence.disko = {
      device = "/dev/nvme0n1";
      swapSize = "100G";
    };
    __cfg.secureboot.enable = true;
    __cfg.sops.enable = true;

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "psy-fw13"; # Define your hostname.

    # wireguard home
    networking.wg-quick.interfaces.wg0 = {
      configFile = "/run/secrets/wireguard/homenet2/configFile";
      autostart = false;
    };

    __cfg.shares.luna.credentials = "/run/secrets/samba/luna/credentials";

    __cfg.mainUser = "psy";

    # services.xserver.desktopManager.gnome.enable = true;
    programs.hyprland.enable = true;

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
