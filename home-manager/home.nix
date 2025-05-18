# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    # ./modules/awesomewm/default.nix
    ./modules/fonts.nix
    ./modules/kitty.nix
    ./modules/neovim.nix
    ./modules/zsh.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "psy";
    homeDirectory = "/home/psy";
  };

  # home.file."${config.home.homeDirectory}/.config/nvim" = {
  #   source = pkgs.fetchgit {
  #     url = "https://github.com/suicide/nvim-conf";
  #     rev = "656158c689d956ffcd90dda6bfe3c64118c7f104";
  #     hash = "sha256-d81O23g0aTUSHKwj2Yoi6pqfSQtRrMbZzbl6zr2IyzM=";
  #   };
  #   recursive = true;
  # };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "psy";
    userEmail = "psy@test1.test";
  };

  programs.firefox.enable = true;

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
  };

  wayland.windowManager.hyprland = {
    enable = false;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, F, exec, firefox"
      ];
    };
  };

  home.packages = with pkgs; [ ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
