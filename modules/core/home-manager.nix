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
  };
}
