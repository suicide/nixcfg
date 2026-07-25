{
  config,
  inputs,
  ...
}: {
  flake.nixosConfigurations.psy-fw13 = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      self = inputs.self;
      outputs = inputs.self.outputs;
      hostname = "psy-fw13";
    };
    modules = [
      config.internal.modules.nixos.sops
      config.internal.modules.nixos.home-manager
      config.internal.modules.nixos.psy
      ../../hosts/psy-fw13/configuration.nix
    ];
  };
}
