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
      config.internal.modules.nixos.bluetooth
      config.internal.modules.nixos.hyprland
      config.internal.modules.nixos.containers
      config.internal.modules.nixos.qmk
      config.internal.modules.nixos.desktop
      config.internal.modules.nixos.powermanagement
      config.internal.modules.nixos.wifi
      config.internal.modules.nixos.audio
      config.internal.modules.nixos.tpm
      ../../hosts/psy-work1/configuration.nix
    ];
  };
}
