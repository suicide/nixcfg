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
      config.internal.modules.nixos.nix
      config.internal.modules.nixos.base
      config.internal.modules.nixos.linux-base
      config.internal.modules.nixos.boot
      config.internal.modules.nixos.gc
      config.internal.modules.nixos.firewall
      config.internal.modules.nixos.sops
      config.internal.modules.nixos.home-manager
      config.internal.modules.nixos.psy
      config.internal.modules.nixos.secureboot
      ../../hosts/psy-work1/configuration.nix
    ];
  };
}
