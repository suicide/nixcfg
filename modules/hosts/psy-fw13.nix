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
      config.internal.modules.nixos.bluetooth
      config.internal.modules.nixos.hyprland
      config.internal.modules.nixos.containers
      config.internal.modules.nixos.laptop
      config.internal.modules.nixos.powermanagement
      config.internal.modules.nixos.wifi
      ../../hosts/psy-fw13/configuration.nix
    ];
  };
}
