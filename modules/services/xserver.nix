{
  inputs,
  lib,
  ...
}: {
  internal.modules = {
    nixos.xserver = {
      config,
      pkgs,
      ...
    }: let
      impermanenceCfg = config.__cfg.impermanence;
      hyprlandPkgs = import ./hyprland/_hyprland-packages.nix {inherit inputs pkgs;};
    in {
      config = {
        # Enable the X11 windowing system.
        services.xserver.enable = true;

        # Enable touchpad support (enabled default in most desktopManager).
        # services.xserver.libinput.enable = true;

        # Enable the GNOME Desktop Environment.
        # services.displayManager.gdm = {
        #   enable = true;
        #   wayland = true;
        # };
        services.displayManager.sddm = {
          enable = true;
          package = pkgs.kdePackages.sddm;
          # extraPackages = [ pkgs.catppuccin-sddm ];
          theme = "catppuccin-mocha-mauve";

          settings = {
            Users = {
              RememberLastUser = true;
              RememberLastSession = false;
            };
          };
        };

        environment = {
          systemPackages = with pkgs; [
            catppuccin-sddm
          ];
          persistence.${impermanenceCfg.persistDir} = {
            files = [
              "/var/lib/sddm/state.conf"
            ];
          };
        };

        # services.xserver.desktopManager.gnome.enable = true;
        # services.xserver.windowManager.awesome = {
        #   enable = true;
        # };

        # Enable Hyprland
        programs.hyprland = {
          #   enable = true;
          xwayland.enable = true;
          withUWSM = true;

          package = hyprlandPkgs.hyprland;
          portalPackage = hyprlandPkgs.portal;
        };

        environment.sessionVariables = lib.mkIf (config.programs.hyprland.enable) {
          # hint chromium based apps to use wayland
          NIXOS_OZONE_WL = "1";
        };

        # Configure keymap in X11
        services.xserver.xkb = {
          layout = "us";
          variant = "";
        };
      };
    };
  };
}
