{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # disko
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # impermanence
    impermanence.url = "github:nix-community/impermanence";
    impermanence.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    mkSystem = config: nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs;};
      # path to host specific config modules
      modules = [
        config
      ];
    };
    mkHome = arch: config: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${arch}; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        # specific config file
        modules = [config];
      };
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      psy-fw13 = mkSystem ./hosts/psy-fw13/configuration.nix;
      qemu = mkSystem ./hosts/qemu/configuration.nix;
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "psy@psy-fw13" = mkHome "x86_64-linux" ./home-manager/home.nix;
    };
  };
}
