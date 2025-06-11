{ config, pkgs, inputs, ... }:

{
  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes"];

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # to enable hibernate from a swapfile on btrfs
    # see https://github.com/nix-community/disko/issues/651
    boot.initrd.systemd.enable = true;

    # Enable networking
    networking.networkmanager.enable = true;

    programs.zsh.enable = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      git
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      clang
      gnumake
    ];

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    security.sudo = {
      enable = true;
      extraConfig = ''
        Defaults     !lecture
      '';
    };
  };
}
