{...}: {
  internal.modules = {
    # Existing NixOS hyprland service (cachix config).
    nixos.hyprland = {
      nix.settings = {
        substituters = ["https://hyprland.cachix.org"];
        trusted-substituters = ["https://hyprland.cachix.org"];
        trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      };
    };

    home.hyprland = {
      config,
      pkgs,
      inputs,
      lib,
      ...
    }: {
      imports = [
        ./_hyprland.nix
      ];
    };
  };
}
