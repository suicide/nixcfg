{inputs, ...}: {
  internal.modules = {
    nixos.impermanence = {
      imports = [
        inputs.disko.nixosModules.default
        ./_impermanence/default.nix
        ./_impermanence/users/psy.nix
      ];
    };
  };
}
