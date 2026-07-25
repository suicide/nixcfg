{
  config,
  inputs,
  ...
}: {
  flake.nixosConfigurations.qemu = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      self = inputs.self;
      outputs = inputs.self.outputs;
      hostname = "qemu";
    };
    modules = [
      config.internal.modules.nixos.sops
      config.internal.modules.nixos.home-manager
      config.internal.modules.nixos.psy
      ../../hosts/qemu/configuration.nix
    ];
  };
}
