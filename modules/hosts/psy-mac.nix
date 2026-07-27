{
  config,
  inputs,
  ...
}: {
  flake.darwinConfigurations.psy-mac = inputs.nix-darwin.lib.darwinSystem {
    specialArgs = {
      inherit inputs;
      self = inputs.self;
      outputs = inputs.self.outputs;
      hostname = "psy-mac";
    };
    system = "aarch64-darwin";
    modules = [
      config.internal.modules.darwin.nix
      config.internal.modules.darwin.sops
      config.internal.modules.darwin.home-manager
      config.internal.modules.darwin.psy
      config.internal.modules.darwin.appearance
      config.internal.modules.darwin.finder
      config.internal.modules.darwin.brew
      config.internal.modules.darwin.apps
      config.internal.modules.darwin.colima
      ./_psy-mac/configuration.nix
    ];
  };
}
