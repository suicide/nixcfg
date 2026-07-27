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
      config.internal.modules.nixos.nix
      config.internal.modules.nixos.base
      config.internal.modules.nixos.linux-base
      config.internal.modules.nixos.boot
      config.internal.modules.nixos.gc
      config.internal.modules.nixos.firewall
      config.internal.modules.nixos.sops
      config.internal.modules.nixos.home-manager
      config.internal.modules.nixos.psy
      config.internal.modules.nixos.impermanence
      config.internal.modules.nixos.xserver
      ./_qemu/configuration.nix
    ];
  };
}
