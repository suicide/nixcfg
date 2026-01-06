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
    ./modules/common.nix

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    # ./modules/awesomewm/default.nix
    ./modules/hyprland
    ./modules/waybar
    ./modules/rofi.nix
    ./modules/dunst.nix
    ./modules/fonts.nix
    ./modules/gtk.nix

    ./modules/kitty.nix
    ./modules/zsh.nix
    ./modules/git.nix
    ./modules/tmux.nix
    ./modules/gpg.nix
    ./modules/ssh.nix
    ./modules/direnv.nix

    ./modules/neovim/neovim.nix
    ./modules/neovim/mcphub.nix

    ./modules/ai/copilot-cli.nix
    ./modules/ai/opencode.nix

    ./modules/network.nix

    # ./modules/virtualization/container-tools.nix
    # ./modules/virtualization/podman.nix

    ./modules/sops.nix

    ./modules/xdg.nix

    ./modules/browsers

    ./modules/yazi
    ./modules/playerctl.nix
    ./modules/mpv.nix
    ./modules/feh.nix
    ./modules/zathura.nix

    # causes weird infinite resucsion error, but using home manager might not be useful due to bindfs performance
    # inputs.impermanence.homeManagerModules.impermanence
    # ./modules/impermanence.nix
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

  # Enable home-manager and git
  programs.home-manager.enable = true;

  home.packages = with pkgs; [];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
