{ config, pkgs, inputs, ... }:

{
  config = {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    # services.xserver.desktopManager.gnome.enable = true;
    # services.xserver.windowManager.awesome = {
    #   enable = true;
    # };

    # Enable Hyprland
    programs.hyprland = {
    #   enable = true;
      xwayland.enable = true;
    };

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

  };
}

