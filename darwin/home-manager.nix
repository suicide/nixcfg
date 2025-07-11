{
  config,
  pkgs,
  inputs,
  lib,
  hostname,
  ...
}: {
  config = {
    home-manager = {
      sharedModules = [
        inputs.sops-nix.homeManagerModules.sops
      ];
      extraSpecialArgs = {inherit inputs;};
    };

    home-manager.users.${config.system.primaryUser} = {
      imports = [
        ../home-manager/home-darwin.nix
        # ../home-manager/users/${config.system.primaryUser}
        ../hosts/${hostname}/home.nix
      ];
    };
  };
}
