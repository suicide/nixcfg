{inputs, ...}: {
  internal.modules = {
    nixos.home-manager = {
      imports = [inputs.home-manager.nixosModules.home-manager];
      home-manager = {
        sharedModules = [inputs.sops-nix.homeManagerModules.sops];
        extraSpecialArgs = {inherit inputs;};
      };
    };

    darwin.home-manager = {
      imports = [inputs.home-manager.darwinModules.home-manager];
      home-manager = {
        sharedModules = [inputs.sops-nix.homeManagerModules.sops];
        extraSpecialArgs = {inherit inputs;};
      };
    };

    # Core HM baseline: both platforms.
    home.base = {
      lib,
      pkgs,
      ...
    }: {
      config = {
        nixpkgs.config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
        programs.home-manager.enable = true;
        home.stateVersion = "25.05";
      };
    };

    # Linux-only HM baseline.
    home.linux-base = {config, ...}: {
      config = {
        systemd.user.startServices = "sd-switch";
      };
    };
  };
}
