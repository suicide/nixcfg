{
  config,
  pkgs,
  inputs,
  ...
}: {
  config = {
    home-manager = {
      sharedModules = [
        inputs.sops-nix.homeManagerModules.sops
      ];
      extraSpecialArgs = {inherit inputs;};
    };
  };
}
