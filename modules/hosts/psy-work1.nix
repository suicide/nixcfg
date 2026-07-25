{
  config,
  inputs,
  ...
}: {
  flake.nixosConfigurations.psy-work1 = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      self = inputs.self;
      outputs = inputs.self.outputs;
      hostname = "psy-work1";
    };
    modules = [
      config.internal.modules.nixos.sops
      config.internal.modules.nixos.home-manager
      config.internal.modules.nixos.psy
      config.internal.modules.nixos.secureboot
      ../../hosts/psy-work1/configuration.nix
    ];
  };
}
