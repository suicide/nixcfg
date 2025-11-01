{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.asus-rog-strix-x570e

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
    ../../nixos/desktop.nix

    ../../nixos/audio.nix
    ../../nixos/bluetooth.nix
    ../../nixos/firewall.nix
    ../../nixos/wifi.nix
    ../../nixos/xserver.nix
    ../../nixos/hyprland.nix

    ../../nixos/network/shares.nix

    ../../nixos/virtualization/containers.nix

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
      swapSize = "64G";
    };
    __cfg.secureboot.enable = true;
    __cfg.sops.enable = true;

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;
    # stick with 6.15
    # boot.kernelPackages = pkgs.linuxPackages_6_15;

    networking.hostName = "psy-work1"; # Define your hostname.

    # wireguard home
    networking.wg-quick.interfaces.wg0 = {
      configFile = "/run/secrets/wireguard/homenet2/configFile";
      autostart = false;
    };

    __cfg.shares.luna.credentials = "/run/secrets/samba/luna/credentials";

    __cfg.mainUser = "psy";

    # services.xserver.desktopManager.gnome.enable = true;
    programs.hyprland.enable = true;

    __cfg.audio.defaultVolume = 0.3;

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Set your time zone.
    time.timeZone = "Europe/Berlin";

    services = {
      ## power management, recommended by framework
      power-profiles-daemon.enable = true;
      tlp.enable = false;

      ## disable wakeup from usb peripherals
      udev.extraRules = ''
        ACTION=="add" SUBSYSTEM=="pci" ATTR{vendor}=="0x1022" ATTR{device}=="0x149c" ATTR{power/wakeup}="disabled"
      '';
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.05"; # Did you read the comment?
  };
}
